class ProfileDataController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"auth_token":"NRvwBNzqZQkni2rHsuAX"}' http://localhost:3000/getinfluence.json

  def getInfluence
  	@user = current_user
  	@user.update_info_recal_influence #delete after trials
    render :status=>200, :json=>{:influence=> @user.influence}
  end


end
