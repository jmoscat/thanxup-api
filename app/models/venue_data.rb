class VenueData
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

end
