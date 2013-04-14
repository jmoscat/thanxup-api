class ProfileDataController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d '{"auth_token":"Jqomaqibzs1iBHN2FE3N"}' http://localhost:3000/getinfluence.json

  def getInfluence
  	@user = current_user
  	@user.update_info_recal_influence #delete after trials
    render :status=>200, :json=>{:influence=> @user.influence}
  end


  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"Jqomaqibzs1iBHN2FE3N", "altitude":"12.3452", "longitude":"121312"}' http://localhost:3000/getvenue.json

	def getVenue
		lat = params[:altitude]
		lon = params[:longitude]
		render :status =>200, :json=> Venue.getClosestVenues(lat,lon)
 	end

  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"Jqomaqibzs1iBHN2FE3N", "venue_id":"121231"}' http://localhost:3000/checkin.json
  def checkin
    @user = current_user
    venue_id = params[:venue_id]
    if @user.saveVisit(venue_id)
      render :status =>200, :json=> {:status => "Success"}
      Venue.saveVisit(@user.user_uid, venue_id)
    else 
      render :status =>200, :json=> {:status => "Ya has hecho checkin hoy, gracias!"}
    end
  end

    #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"Jqomaqibzs1iBHN2FE3N"}' http://localhost:3000/getcupons.json
  def getCupons
    render :status => 200, :json => Cupon.getCupons(current_user.user_uid)
  end




end
