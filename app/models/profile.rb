require 'ripple'
class Profile
	include Ripple::Document
	property :user_uid,         String, index: true
	property :fb_token, 				String, presence: true
	property :name,            	String
	property :email,						String
	property :location_name, 		String
	property :location_id, 			String
	property :DOB,							Time
	property :friend_count,			Integer
	property :influence,				Float



	def self.new_profile(uid,fb_token)
		new_prof = Profile.new
		new_prof.key = uid
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
		self.DOB = profile["birthday"]
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

