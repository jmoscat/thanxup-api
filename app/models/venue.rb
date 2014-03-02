require 'rest_client'

class Venue
  include Mongoid::Document
  include Mongoid::Timestamps
  field :venue_id, type: String
  field :name, type: String, default: ""
  field :web, type: String, default: ""
  field :fb_page, type: String, default: ""
  field :place_id, type: String, default: ""
  field :contact_name, type: String, default: ""
  field :email, type: String, default: ""
  field :venue_tag, type: String, default:""
  # 0: cafe, 1:copas, 2:restaurante, 3 cine, 4 man-clothing, 5 woman clothing 
  field :kind, type: String, default: ""  #Copas, comida, etc...
  field :passcode, type: String, default: ""
  field :image_link, type: String, default: ""
  field :address, type: String, default: ""
  field :telf, type: String, default: ""
  field :time, type: String, default: ""
  field :location, :type => Array

  field :latitude, type: String, default: ""
  field :longitude, type: String, default: ""
  field :avatar, type: String
  has_many :offers
  has_many :venue_visits
  index({ location: '2d' }, { min: -200, max: 200 })
  index({venue_id: 1}, {unique: true})

  def self.getClosestVenues(lat, lon)
    loc = []
    loc << lat.to_f
    loc << lon.to_f
    venues = Venue.where(:location => {"$near" => loc})
    venue_respond = []
    venues.each do |u|
      if u.offers.first.nil?
        text = "No hay ninguna oferta ahora mismo"
        fb = ""
      else
        text = u.offers.first.offer_text
        fb = u.offers.first.fb_post
      end
      venue_respond << {
        :venue_id => u.venue_id, 
        :venue_name => u.name, 
        :venue_tag => u.venue_tag,
        :venue_web => u.web,
        :venue_kind => u.kind,
        :venue_icon => u.image_link,
        :venue_address => u.address, 
        :fb_post => fb,
        :lat => u.location[0], 
        :lon => u.location[1], 
        :offer_text => text,
        :time => u.time,
        :telf => u.telf
      }
    end
    return venue_respond.to_json
  end

  def self.saveVisit(user_id, venue_id)
    #We should also check here if user has checkin already...later on...
    venue = Venue.find_by(venue_id: venue_id)
    #Save visit with current count of visit (including this one)
    count = VenueVisit.where(user_fb_id: user_id).count(true)
    count = count + 1
    user = User.find_by(user_uid:user_id)
    influence = user.influence
    #Launch offer
    offer = venue.offers.first
    if offer.nil?
      return "No offer"
    else
      if offer.offer_kind == "1"
        #[(newmax - newmin)*(tweet_score - oldmin)]/(oldmax - oldmin)
        discount = ((offer.discount_max - 0.0)*(influence + 0.01))/(0.98-0.0)
        if discount <= 0.03
          discount = 0.03
        end
        cupon_text = (discount*100.0).round.to_s + "% de descuento en "+ offer.discount_thing
        Venue.cupon_from_template(offer, cupon_text,user_id,venue_id,user.name, venue.name, venue.passcode, venue.kind, venue.address)

      elsif offer.offer_kind == "2"
        if influence >= offer.gift_min_inf
          Venue.cupon_from_template(offer, offer.cupon_text,user_id,venue_id,user.name, venue.name, venue.passcode, venue.kind, venue.address)
        end
      end

      venue.venue_visits.push(VenueVisit.new(venue_id: venue_id, venue_raw_id: venue_id ,user_fb_id: user_id, user_influence:influence ,visit_count: count, shared: true))
      venue.save
    end
    # Send notification to user
  end

  def self.cupon_from_template(offer,cupon_text ,user_id, venue_id, user_name, venue_name, venue_pass, venue_kind, venue_address)
    if Rails.env.development?
      url = ENV["DEV_CUPON"]
    elsif Rails.env.production?
      url = ENV["PROD_CUPON"]
    end
    respond = RestClient.post url, {:user_name => user_name, :venue_name => venue_name,:venue_kind => venue_kind, :venue_address => venue_address  ,:venue_pass => venue_pass ,:user_id => user_id, :venue_id => venue_id, :cupon_text => cupon_text, :valid_from => offer.cupon_valid_from, :valid_until => offer.cupon_valid_until, :kind => offer.kind, :social_text => offer.social_text, :social_count => offer.social_count, :social_limit => offer.social_limit, :social_from => offer.social_from, :social_until => offer.social_until}.to_json, :content_type => :json, :accept => :json
    puts respond
  end


end
