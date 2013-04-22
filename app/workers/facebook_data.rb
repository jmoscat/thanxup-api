class FacebookData
    include Sidekiq::Worker
    sidekiq_options :retry => 2
	#sidekiq_options :queue => facebook_import_worker
	def perform(user_id)
				Influence.update_info_recal_influence(user_id)
	end
end
