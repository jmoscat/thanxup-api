class FacebookData
    include Sidekiq::Worker
	#sidekiq_options :queue => facebook_import_worker
	def perform(uid)
    	user=User.find_by(user_uid: uid)
    	@graph = Koala::Facebook::API.new(user.fb_token)
        profile = @graph.get_object("me")
        user.email = profile["email"]
        user.name = profile["name"]
        user.location_name = profile["location"]["name"]
        user.location_id = profile["location"]["id"]
        user.DOB = Date.strptime(profile["birthday"], '%m/%d/%Y')

        #get_friends
        friends = Array.new
        @graph.get_connections("me","friends",:fields =>"id").each do |x|
          friends << x["id"]
        end

        user.fb_friends = friends
        num = @graph.fql_query("SELECT friend_count FROM user WHERE uid = me()")
        user.friend_count = num.first["friend_count"]
        user.save
	end
end
