class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_uid, type: String
  field :fb_token, type: String
  field :encrypted_password, type: String, default: ""
  field :authentication_token, type: String
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
  #field :consumed_friends_cupons_overall, type: Integer
  #field :consumed_frined_cupons_week, type: Integer
  #field :weekly_shares, type:Integer
  index({user_uid: 1}, {unique: true, background: true})

  has_many :visits
  has_many :weeklies




  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :uid, :fb_access_token, :remember_me
  

  def self.create_new(fb_uid, fb_token)
  	graph = Koala::Facebook::API.new(fb_token)
  	profile = graph.get_object("me")

  	if profile.nil? or profile["id"] != fb_uid
  		return nil
  	else
  		new_user = User.new
  		new_user.user_uid = fb_uid
  		new_user.fb_token = fb_token
  		new_user.save

      #gets all Facebook data and calculates influence async
      FacebookData.perform_async(new_user.user_uid)
  		
      return new_user
  	end
  end

  def update_fb_token(fb_token)
    self.fb_token = fb_token
    self.save
  end

  def saveVisit(venue_id)
    #check if it has checkin already, checkin on facebook regardless...
    last_visit = self.visits.where(:venue_id => venue_id).last
    if last_visit.nil?
      #self.checkin(venue_id)
      Checkin.perform_async(self.user_uid, venue_id)
      self.visits.push(Visit.new(venue_id: venue_id, shared: true))
      self.save
      return true
    elsif (((Time.now - last_visit.created_at)/3600) >= 24.0)
      #self.checkin(venue_id)
      Checkin.perform_async(self.user_uid, venue_id)
      self.visits.push(Visit.new(venue_id: venue_id, shared: true))
      self.save
      return true
    else  
      return false
    end
  end

  def checkin(venue_id)
    venue = Venue.where(:venue_id => venue_id).last
    graph = Koala::Facebook::API.new(self.fb_token)
    if (venue.offers.last.nil?)
      return "CHECKIN STATUS: Saved, no offer to share"
    else
      graph.put_wall_post(venue.offers.last.fb_post, {"place" => venue.place_id})
      return "CHECKIN STATUS: Shared"
    end
  end

  def historical
    self.weeklies.to_json(:only => [:created_at, :influence, :shared_cupons, :consumed_ff_cupons])
  end

  def self.getCupons(user_id)
  user=User.find_by(user_uid: user_id
  return Cupon.where(user_fb_id: user_id, used: false).to_json(:only => [ :_id, :store_id, :cupon_text, :valid_from, :valid_until, :kind ])
end



end
