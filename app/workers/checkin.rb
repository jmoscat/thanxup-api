class Checkin
    include Sidekiq::Worker
    sidekiq_options :retry => 2
	#sidekiq_options :queue => facebook_import_worker
	def perform(user_id, venue_id)
		test = User.find_by(user_uid: user_id)
		test.checkin(venue_id)
	end
end
