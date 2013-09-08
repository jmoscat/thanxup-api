class Api::AppLoginController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

    #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"uid":"545887286", "iphone_token":"1231231","fb_access_token":"CAACEdEose0cBAFb7KKfkVvbieftwVkad8pGOP1CQnvPyZAyFq42C6yPxuvyfwmhZBUHrREcuURyyUMrvWi2lri6SmFxKQdhZCj4J4wWyi7y9OgrFFgZCNtG5ozciS39YhctLO8SFPk6hiOKsTRhLaShJJiZAe5m8ZD"}' http://localhost:3000/api/app_login.json
    #curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"uid":"100005420705218","fb_access_token":"AAACEdEose0cBAJZCx4z04AlUM3TC3TK07Xr9wqqJbIAANqTimpKfDnO6KXp6ArtapQMWmuM51SZCV4T1b5JT2mfuTh99efnZBTiqeagr0oZCR74Y0hGV"}' http://localhost:3000/api/app_login.json



    #http://matteomelani.wordpress.com/2011/10/17/authentication-for-mobile-devices/
  def create
    uid = params[:uid]
    fb_access_token = params[:fb_access_token]
    iphone_token = params[:iphone_token]
    if request.format != :json
      render :status=>406, :json=>{:message=>"The request must be json"}
      return
    end

    if uid.nil?
      render :status=>400,
              :json=>{:message=>"Missing UID"}
      return
    end

    if fb_access_token.nil?
      render :status=>400,
              :json=>{:message=>"Missin Facebook Access Token"}
      return
    end

    @user=User.find_by(user_uid: uid.downcase)

    if @user.nil? #if USER is new
      @user = User.create_new(uid, fb_access_token,iphone_token)
      if @user.nil? #access_token failed or UID was not valid (user is not created)
        logger.info("Failed to create user, uid not valid")
        render :status=>401, :json=>{:message=>"Failed to create user, uid not valid"}
        return
      else
        @user.ensure_authentication_token!
        render :status=>200, :json=>{:thanxup_token=>@user.authentication_token}
      end
    else
      @user.ensure_authentication_token!
      @user.update_iphone_token(iphone_token)
      @user.update_fb_token(fb_access_token)
      render :status=>200, :json=>{:thanxup_token=>@user.authentication_token}
    end

    # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    #@user.update_fb_token()
      
  end

  def destroy
    @user=User.find_by(authentication_token: params[:id])
    if @user.nil?
      logger.info("Token not found")
      render :status=>404, :json=>{:message=>"Invalid token."}
    else
      @user.reset_authentication_token!
      render :status=>200, :json=>{:token=>params[:id]}
    end
  end
end