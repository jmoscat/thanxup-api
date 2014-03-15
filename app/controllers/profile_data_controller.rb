class ProfileDataController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d '{"auth_token":"KV7bgfUkUoLkxUVxrqm9"}' http://new2010.es:3000/getinfluence.json

  def getInfluence
    #x = current_user.login_times+1 
  	#current_user.login_times = x
    #current_user.save

  	#@user.update_info_recal_influence #delete after trials
    #influence = (@user.weeklys.last.influence*100).round
    current_user.logintimes
    stats = current_user.weeklies.last
    previous_inf = current_user.weeklies.offset(1).last
    influence = (current_user.influence*100.0).round
    if !previous_inf.nil?
      change =  "+" + ((influence - previous_inf.influence).round).to_s + "%"
    else
      change = "0"
    end
    render :status=>200, :json=>{:influence=> influence, :cupons => stats.new_cupons, :shared => stats.shared_cupons, :change => change }
  end


  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"HpW9f2xstgBEzz9p1BxK", "altitude":"40.474224", "longitude":"-3.720311"}' http://new2010.es:3000/getvenue.json

	def getVenue
		lat = params[:altitude]
		lon = params[:longitude]
    PlaceSave.perform_async(current_user.user_uid,lat, lon)
		render :status =>200, :json=> Venue.getClosestVenues(lat,lon)
 	end

  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"iTwDA2MqNAk45qXFyx8z", "venue_id":"121231"}' http://localhost:3001/checkin.json
  def checkin
    venue_id = params[:venue_id]
    if current_user.saveVisit(venue_id)
      VenueSavevisit.perform_async(current_user.user_uid, venue_id)
      render :status =>200, :json=> {:status => "Compartido! En breves recibiras un cupon!"}
    else 
      render :status =>200, :json=> {:status => "Hoy ya has hecho checkin..."}
    end
  end

    #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"iTwDA2MqNAk45qXFyx8z"}' http://localhost:3001/gethistory.json
  def getCupons
    render :status => 200, :json => Cupon.getCupons(current_user.user_uid)
  end

  def gethistory
    render :status => 200, :json => current_user.historical
  end

  def delete
    
    render :status =>200, :json=> {:status => "Success"}
  end

  def signout
    current_user.setnotifyfalse
    render :status =>200, :json=> {:status => "Success"}
  end


end
