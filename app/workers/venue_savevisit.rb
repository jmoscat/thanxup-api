class VenueSavevisit
    include Sidekiq::Worker
    sidekiq_options :retry => 2
	#sidekiq_options :queue => facebook_import_worker
	def perform(user_id, venue_id)
				Venue.saveVisit(user_id, venue_id)
	end
end
