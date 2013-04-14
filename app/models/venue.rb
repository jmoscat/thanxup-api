class Venue
  include Mongoid::Document
  include Mongoid::Timestamps
  field :venue_id, type: String
  field :name, type: String
  field :web, type: String
  field :fb_page, type: String
  field :place_id, type: String
  field :contact_name, type: String
  field :email, type: String
  field :passcode, type: String
  field :image_link, type: String
  field :address, type: String
  field :latitude, type: String
  field :longitude, type: String
  has_many :offers
  embeds_many :venue_visits

  index({venue_id: 1}, {unique: true})

  def self.getClosestVenues(lat, lon)
    venues = Venue.all
    venue_respond = []
    venues.each do |u|
      if u.offers.first.nil?
        text = "No hay ninguna ahora mismo pero haz checkin para que nos acordemos de ti!"
      else
        text = u.offers.first.offer_text
      end
      venue_respond << {
        :venue_id => u.venue_id, 
        :venue_name => u.name , 
        :venue_web => u.web, 
        :venue_fb => u.fb_page, 
        :venue_address => u.address, 
        :lat => u.latitude, 
        :lon => u.longitude,
        :offer_day => u.image_link, 
        :offer_text => text
      }
    end
    return venue_respond.to_json
  end

  def self.saveVisit(user_id, venue_id)
    #We should also check here if user has checkin already...later on...
    venue = Venue.find_by(venue_id: venue_id)
    venue.venue_visits.push(VenueVisit.new(venue_id: venue_id, user_fb_id: user_id ,shared: true))
    venue.save
    user = User.find_by(user_uid:user_id)
    
    #Launch offer
    offer = venue.offers.first
    if offer.nil?
      return "No offer"
    else
      if user.influence > offer.influence_1 and user.influence <= offer.influence_2
        template = offer.cupon_templates.find_by(template_id: "1")
      elsif user.influence > offer.influence_2 and user.influence <= offer.influence_3
        template = offer.cupon_templates.find_by(template_id: "2")
      elsif user.influence > offer.influence_3
        template = offer.cupon_templates.find_by(template_id: "3")
      end  
      Cupon.cupon_from_template(template,user_id,venue_id)      
    end
    # Send notification to user

  end

  
  





end
