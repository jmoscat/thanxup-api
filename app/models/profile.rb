require 'ripple'

class Profile
	include Ripple::Document
	property :user_uid,         String, index: true
	property :fb_token, 				String, presence: true
	property :name,            	String, presence: true
	property :email,						String
	property :location, 				String
	property :num_friends,				Integer
	property :influence,					Float



	def new_profile(uid,fb_token)
		new_prof = Profile.new
		new_prof.key = user_uid
		new_prof.user_uid = user_uid
		new_prof.fb_token = fb_token
		new_prof.save
	end

	def update_access_token(token)
		self.fb_token = token
		self.save
	end

 private 
	def get_facebook_data (fb_token)
		@graph = Koala::Facebook::API.new(fb_token)
		profile = @graph.get_object("me")
	end

	def calculate_influence

	end

	def get_cupons

	end

	def get_friends

	end

end

