#RAILS_ENV=production rake weekly
task :weekly => :environment do
  Influence.weekly
end