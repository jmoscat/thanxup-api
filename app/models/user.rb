class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :uid, :fb_access_token, :remember_me

  def self.create_new(fb_uid, fb_token)
  	@graph = Koala::Facebook::API.new(fb_token)
  	profile = @graph.get_object("me")

  	if profile.nil? or profile["id"] != fb_uid
  		return nil
  	else
  		new_user = User.new()
  		new_user.uid = fb_uid
  		new_user.fb_access_token = fb_token
  		new_user.save
  		return new_user
  	end
  end
end
