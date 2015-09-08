class RailsDbLocalize::Railtie < Rails::Railtie
  rake_tasks do
    Dir[File.join(RailsDbLocalize::gem_path, "lib/tasks/*.rake")].each{ |f| load f }
  end
end
