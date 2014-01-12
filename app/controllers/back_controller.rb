class BackController < ApplicationController
 respond_to :json

	def addshare
		user=User.find_by(user_uid: params[:user_id])
		user.weeklies.ascending(:created_at).last.addShared(params[:count])
		render :status =>200, :json=> {:status => "Success"}
	end

	def addconsume
		user=User.find_by(user_uid: params[:user_id])
		user.weeklies.ascending(:created_at).last.consumed(params[:count])
		render :status =>200, :json=> {:status => "Success"}
	end

	def socialnotify
		NotifyFriends.perform_async(params[:cupons], params[:friends], params[:user_id], params[:venue_id])
		render :status => 200, :json=> {:status => "Success"}
	end

	def getmobile
		user=User.find_by(user_uid: params[:user_id])
		render :status => 200, :json=> {:mobile => user.iphone_id}
	end

	def notifycupon
		user = User.find_by(user_uid: params[:user_id])
		Notification.cupon_notify(user.iphone_id)
		render :status => 200, :json=>{:status => "ok"}
	end

	#curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"cupon_id":"ae4d6084ab064fac982fb608cbd9bd1aa4c4b77a32a5a652f947e05b8b0a3e13"}' http://coupon.thanxup.com/api/share.json
	def getoffer
		venue_id = params[:venue_id]
	    offer = Venue.find_by(venue_id: venue_id).offers.first
	    if offer.nil?
	      render :status =>200, :json=> {:status => "0"}
	    else
	    render :status =>200, :json=> offer.getOffer
	   	end
	end

	def deleteoffer
		venue_id = params[:venue_id]
		offer = Venue.find_by(venue_id: venue_id).offers.first
		if offer.nil?
	      render :status =>200, :json=> {:status => "1"}
	    else
	      Venue.find_by(venue_id: venue_id).offers.first.delete
	      render :status =>200, :json=> {:status => "1"}
	   	end
	end
	def setoffer
		Offer.setOffer(params)
		render :status =>200, :json=> {:status => Offer.setOffer(params)}
	end



end
