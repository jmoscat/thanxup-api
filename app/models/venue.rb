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
  # 0: cafe, 1:copas, 2:restaurante, 3 textil
  field :kind, type: String, default: ""  #Copas, comida, etc...
  field :passcode, type: String, default: ""
  field :image_link, type: String, default: ""
  field :address, type: String, default: ""
  field :telf, type: String, default: ""
  field :time, type: String, default: ""
  field :latitude, type: String, default: ""
  field :longitude, type: String, default: ""
  field :avatar, type: String
  has_many :offers
  has_many :venue_visits

  index({venue_id: 1}, {unique: true})

  def self.getClosestVenues(lat, lon)
    venues = Venue.all
    venue_respond = []
    venues.each do |u|
      if u.offers.first.nil?
        text = "No hay ninguna oferta ahora mismo pero haz checkin para que nos acordemos de ti!"
        fb = ""
      else
        text = u.offers.first.offer_text
        fb = u.offers.first.fb_post
      end
      venue_respond << {
        :venue_id => u.venue_id, 
        :venue_name => u.name, 
        :venue_web => u.web,
        :venue_kind => u.kind,
        :venue_icon => u.image_link,
        :venue_address => u.address, 
        :fb_post => fb,
        :lat => u.latitude, 
        :lon => u.longitude, 
        :offer_text => text,
        :kind => u.kind,
        :time => u.time,
        :telf => u.telf,
        :address => u.address
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
      if influence > offer.influence_1 and influence <= offer.influence_2
        template = offer.cupon_templates.find_by(template_id: "1")
      elsif influence > offer.influence_2 and influence <= offer.influence_3
        template = offer.cupon_templates.find_by(template_id: "2")
      elsif influence > offer.influence_3
        template = offer.cupon_templates.find_by(template_id: "3")
      end  
      Venue.cupon_from_template(template,user_id,venue_id,user.name, venue.name, venue.passcode, venue.kind, venue.address)      
      venue.venue_visits.push(VenueVisit.new(venue_id: venue_id, venue_raw_id: venue_id ,user_fb_id: user_id, visit_count: count, shared: true))
      venue.save
    end
    # Send notification to user
  end

  def self.cupon_from_template(template, user_id, venue_id, user_name, venue_name, venue_pass, venue_kind, venue_address)
    if Rails.env.development?
      url = ENV["DEV_CUPON"]
    elsif Rails.env.production?
      url = ENV["PROD_CUPON"]
    end
    respond = RestClient.post url, {:user_name => user_name, :venue_name => venue_name,:venue_kind => venue_kind, :venue_address => venue_address  ,:venue_pass => venue_pass ,:user_id => user_id, :venue_id => venue_id, :cupon_text => template.cupon_text, :valid_from => template.valid_from, :valid_until => template.valid_until, :kind => template.kind, :social_text => template.social_text, :social_count => template.social_count, :social_limit => template.social_limit, :social_from => template.social_from, :social_until => template.social_until}.to_json, :content_type => :json, :accept => :json
    puts respond
  end


end
