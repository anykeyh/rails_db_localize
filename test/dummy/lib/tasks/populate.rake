namespace :db do
  desc "Test with random datas"
  task :populate => :environment do
    require 'faker'
    1000.times do |x|
      t = Translatable2.new
      t.name = Faker::Lorem.paragraph
      t.save!
    end
  end
end
