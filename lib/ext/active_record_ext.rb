class ActiveRecord::Base
  class << self

    def has_translations *fields

      unless @__rdbl_translations
        @__rdbl_translations = true
        # Register it mostly to remove the translations once you delete an object
        self.has_many :translations, as: :resource, dependent: :destroy
      end

      fields.each do |field|
        # Add a marker to the schema of the application translations.
        RailsDbLocalize::add_to_schema(self, field)

        # Not sure if I would have to put dependent: :destroy here.
        self.has_many :"#{field}_translations", -> { where(field: field)  }, as: :resource

        # Making the magic happends.
        # I should really learn how to use the Reflection helpers in ActiveRecord, because
        # ruby eval is not the most readable stuff... :o)
        self.class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{field}_translated (lang=nil)
            lang ||= I18n.locale
            RailsDbLocalize::TranslationCache.instance.get_translation_for(self.class, self.id, "#{field}", lang, self.#{field} )
          end

          def #{field}_translated= args
            if args.is_a?(Array)
              value, lang = args
            else
              value = args
              lang = I18n.locale
            end

            if self.id
              translated = RailsDbLocalize::Translation.where(
                resource_type: self.class.to_s, resource_id: self.id,  field: "#{field}", lang: lang
              ).first_or_create

              translated.content = value

              translated.save!
            else
              translations.build field: "#{field}", lang: lang, content: value
            end
          end
        CODE
      end
    end
  end
end