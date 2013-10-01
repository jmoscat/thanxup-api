class VenueController < ApplicationController
	def show
		#image_name = Venue.find_by(venue_id: params[:id]).avatar
		#path = view_context.image_path(image_name)
		#redirect_to (Venue.find_by(venue_id: params[:id]).image_link)

	end

	def site
	   url = "http://" + Venue.find_by(venue_id: params[:id]).fb_page
	   redirect_to url
	end
end
