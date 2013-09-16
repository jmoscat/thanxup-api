class ProfileDataController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d '{"auth_token":"iTwDA2MqNAk45qXFyx8z"}' http://api.thanxup.com/getinfluence.json

  def getInfluence
    #x = current_user.login_times+1 
  	#current_user.login_times = x
    #current_user.save

  	#@user.update_info_recal_influence #delete after trials
    #influence = (@user.weeklys.last.influence*100).round
    influence = (current_user.influence*100).round
    render :status=>200, :json=>{:influence=> influence}
  end


  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"Jqomaqibzs1iBHN2FE3N", "altitude":"12.3452", "longitude":"121312"}' http://localhost:3000/getvenue.json

	def getVenue
		lat = params[:altitude]
		lon = params[:longitude]
		render :status =>200, :json=> Venue.getClosestVenues(lat,lon)
 	end

  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"spCdtaysYsGPPFEdcE4x", "venue_id":"121231"}' http://localhost:3000/checkin.json
  def checkin
    venue_id = params[:venue_id]
    if current_usersaveVisit(venue_id)
      VenueSavevisit.perform_async(current_user.user_uid, venue_id)
      render :status =>200, :json=> {:status => "Success"}
    else 
      render :status =>200, :json=> {:status => "Ya has hecho checkin hoy, tomorrow mas!"}
    end
  end

    #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"Jqomaqibzs1iBHN2FE3N"}' http://localhost:3000/gethistory.json
  def getCupons
    render :status => 200, :json => Cupon.getCupons(current_user.user_uid)
  end

  def gethistory
    render :status => 200, :json => current_user.historical
  end




end
