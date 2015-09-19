class RailsDbLocalize::TranslationCache
  class << self
    def reinit
      @instance = nil
    end

    def instance
      @instance ||= self.new
    end
  end

protected
  def initialize
    @cache = { :data => {}, :cks => {} }
  end

  def encache plucked
    plucked.each do |rt_ri_f_l_c|
      rt,ri,f, l,c = rt_ri_f_l_c #ressource_type, ressource_id, field, lang and content
      @cache[:data][rt]          ||= {}
      @cache[:data][rt][ri]      ||= {}
      @cache[:data][rt][ri][l]   ||= {}
      @cache[:data][rt][ri][l][f] = c
    end
  end

  def is_cached *cks
    cks.each{ |ck| @cache[:cks][ck] ||= true }
  end

public
  # For debug purpose only
  attr_reader :cache

  def prefetch_collections *collections
    # empty string is used here to be sure there's at least one element
    # for IN clause in SQL (otherwise it will fail miserabily)
    in_clause = collections.inject([-1]) do |arr, collection|
      klass = if collection.respond_to?(:klass)
        collection.klass #is a ActiveRecord::Relation
      else
        # Tricky part. sometimes using "all" the collection is already
        # fetched. And there's not really anything to do to get the scope again. except mapping of the primary
        # key but seems tricky, so I prefer raise an error.
        if collection.is_a?(Array)
          raise
            "You're trying to get translations from a collection which is already fetched (SQL request already sent). " +
            "This is happening when you are using map/each/all on the request. Please use the translation cache fetching before the request is sent."
        else
          collection # This is the model
        end
      end

      arr + collection.pluck(klass.primary_key).map do |x|
        RailsDbLocalize::Translation.generate_ck(klass, x)
      end
    end

    is_cached(*in_clause)
    encache RailsDbLocalize::Translation.where("compound_key IN (?)", in_clause).pluck(:resource_type, :resource_id, :field, :lang, :content)
  end

  def get_translation_for model_class, model_id, field, lang, default=nil
    ck = RailsDbLocalize::Translation.generate_ck(model_class, model_id)

    if @cache[:cks][ck]
      #Prefetch was done. Check if there's a value
      @cache[:data][model_class.to_s].try(:[], model_id).try(:[], lang.to_s).try(:[], field.to_s) || default
    else
      #Do the query if no prefetch was done
      RailsDbLocalize::Translation.where(
        resource_type: model_class.to_s, resource_id: model_id, field: field, lang: lang
        ).select(:content).first.try(:content) || default
      # BTW We don't cache it now since a cache is done into ActiveRecord core...
    end

  end

end