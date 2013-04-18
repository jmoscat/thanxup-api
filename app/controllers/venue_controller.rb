class VenueController < ApplicationController
	def show
		redirect_to (Venue.find_by(venue_id: params[:id]).image_link)
	end
end
