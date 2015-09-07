# desc "Explaining what the task does"
# task :rails_db_localize do
#   # Task goes here
# end

namespace :rails_db_localize do
  desc "Remove the orphans in the translations"
  task :delete_orphans => :environment do
    raise "TODO"
  end
end
