class ProfileDataController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d '{"auth_token":"EGmK6BxpPxUwmpkepHSy"}' http://localhost:3000/getinfluence.json

  def getInfluence
  	@user = current_user
  	@user.update_info_recal_influence #delete after trials
    render :status=>200, :json=>{:influence=> @user.influence}
  end


  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d '{"auth_token":"EGmK6BxpPxUwmpkepHSy", "altitude":"12.3452", "longitude":"121312"}' http://localhost:3000/api/getvenue.json
	def getVenue
		lat = params[:altitude]
		lon = params[:longitude]
		render :status =>200, :json=> VenueData.getClosestVenues(lat,lon)
 	end

end
