class Profile
	include Mongoid::Document
	field :user_uid, type: String
	field :fb_token, type: String
	field :name, type: String
	field :email, type: String
	field :location_name, type: String
	field :location_id, type: String
	field :DOB, type: Date

	field :friend_count, type: Integer
	field :fb_friends, type: Array
	field :thanxup_friends, type: Array
	field :NN_thanxup_friends, type: Array

	field :influence, type: Float
	field :iphone_id, type: Integer # for push notifications
	field :android_id, type: Integer # for push notifications
  index({user_uid: 1}, {unique: true})



	def self.new_profile(uid,fb_token)
		new_prof = Profile.new
		new_prof.user_uid = uid
		new_prof.fb_token = fb_token
		new_prof.get_facebook_data
		new_prof.save
	end

	def update_access_token(token)
		self.fb_token = token
		self.save
	end

	def get_facebook_data
		@graph = Koala::Facebook::API.new(self.fb_token)
		profile = @graph.get_object("me")
		self.email = profile["email"]
		self.name = profile["name"]
		self.location_name = profile["location"]["name"]
		self.location_id = profile["location"]["id"]
		self.DOB = Date.strptime(profile["birthday"], '%m/%d/%Y')

		#get_friends
		friends = Array.new
		@graph.get_connections("me","friends",:fields =>"id").each do |x|
			friends << x["id"]
		end

		self.fb_friends = friends
		num = @graph.fql_query("SELECT friend_count FROM user WHERE uid = me()")
		self.friend_count = num.first["friend_count"]
		self.save
	end

 private 


	def calculate_influence

	end

	def get_cupons

	end

	def get_friends

	end

end

