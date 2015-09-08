namespace :rails_db_localize do
  desc "Remove the orphans in the translations"
  task :delete_orphans => :environment do

    # Preload all the models for building the schema.
    # Only useful for development mode when the models are autoloaded.
    RailsDbLocalize::Translation.group(:resource_type).pluck(:resource_type).each do |rt|
      begin
        rt.classify.constantize
      rescue
        puts "Cannot constantize `#{rt}`"
      end
    end

    #Now we have an updated schema,
    # we can remove illegal keys and illegal ids
    to_delete = RailsDbLocalize::Translation
      .where("resource_type NOT IN (?)", [-1, *RailsDbLocalize.schema.keys])

    RailsDbLocalize.schema.each do |klass, field_list|
      klass = klass.classify.constantize
      to_delete += RailsDbLocalize::Translation
        .where("resource_type =? AND ( field NOT IN (?) OR resource_id NOT IN (?) )",
          klass, [-1, *field_list],
          klass.pluck(klass.primary_key))
    end

    puts "REMOVED ORPHANS: #{to_delete.count}"
    to_delete.each(&:destroy)
  end
end
