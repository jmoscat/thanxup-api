class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_uid, type: String
  field :fb_token, type: String
  field :authentication_token, :type => String
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

  embeds_many :cupons
  embeds_many :visits


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
  		new_user = User.new
  		new_user.user_uid = fb_uid
  		new_user.fb_token = fb_token
  		new_user.save
      User.get_facebook_data(new_user)
  		return new_user
  	end
  end

  def self.get_facebook_data(user)
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
