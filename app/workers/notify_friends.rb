class NotifyFriends
    include Sidekiq::Worker
    sidekiq_options :retry => 1
	#sidekiq_options :queue => facebook_import_worker
	def perform(cupons, friends, user_id)
		User.notifyfriends(cupons, friends, user_id)
	end
end
