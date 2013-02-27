class FacebookData
    include Sidekiq::Worker
	#sidekiq_options :queue => facebook_import_worker
	def perform(uid)
        Influence.basicFacebookData(uid)
	end
end
