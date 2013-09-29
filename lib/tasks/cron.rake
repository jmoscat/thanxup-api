#RAILS_ENV=production rake weekly
task :daily => :environment do
  Influence.daily
end