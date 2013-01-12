class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :uid, :fb_access_token, :remember_me
end
