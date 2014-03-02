class PlaceSave
  include Sidekiq::Worker
  sidekiq_options :retry => 1
  	def perform(id, lat, long)
		Location.create_new(id, lat, long)
	end
end