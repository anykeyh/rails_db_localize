$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_db_localize/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_db_localize"
  s.version     = RailsDbLocalize::VERSION
  s.authors     = ["Yacine PETITPREZ"]
  s.email       = ["yacine@redtonic.net"]
  s.homepage    = "https://github.com/anykeyh/rails_db_localize"
  s.summary     = "Manage database translations without any pain."
  s.description = "Translation JIT: You don't need to think about translation in your project until you begin the translation process..."
  s.license     = "APACHE 2.0"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  #s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4"

  s.add_development_dependency "sqlite3", "~> 1"
  s.add_development_dependency "faker", "~> 1.4"
  s.add_development_dependency "better_errors", ">= 2.1"
  s.add_development_dependency "binding_of_caller", ">= 0.7"
end
