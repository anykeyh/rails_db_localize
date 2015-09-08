module RailsDbLocalize
  class << self
    @schema = {}

    # This is the schematics of fields
    # Useful for rake tasks after, to know:
    #   - Which rows are not used anymore (because the field name has changed for example)
    #   - Which models are not yet translated
    attr_reader :schema

    def add_to_schema model, field
      @schema ||= {}
      arr = (@schema[model.to_s] ||= [])
      arr << field unless arr.index(field)
    end

    def load!
      %w(app/models).each do |dir|
        path = File.join(File.expand_path('../..', __FILE__), dir )
        $LOAD_PATH << path
        ActiveSupport::Dependencies.autoload_paths << path
        ActiveSupport::Dependencies.autoload_once_paths.delete(path)
      end
    end

    def gem_path
      @gem_path ||= File.expand_path("..", File.dirname(__FILE__))
    end
  end
end

def __rdbl_require(*args)
  args.each do |path|
    require File.join(File.expand_path("..", __FILE__), path)
  end
end

__rdbl_require 'rails_db_localize/translation_cache'
__rdbl_require 'rails_db_localize/railtie'
__rdbl_require 'ext/active_record_ext', 'ext/controller_ext', 'ext/migration_ext'
RailsDbLocalize::load!