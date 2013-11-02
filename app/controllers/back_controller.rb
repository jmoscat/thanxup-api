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

	def getoffers
	end
end
