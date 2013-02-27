class FacebookData
    include Sidekiq::Worker
	#sidekiq_options :queue => facebook_import_worker
	def perform(uid,graph)
        Influence.basicFacebookData(uid, graph)
	end
end
