class Notification
  def self.influence_notify(iphone_id)
    if (Notification.user_signout(iphone_id))
  	 respond = RestClient.post "https://api.parse.com/1/push", {:where => {:channels=> iphone_id}, :data => {:alert => "Tu influencia ha aumentado, yeeah!!"}}.to_json, :content_type => :json, :accept => :json, 'X-Parse-Application-Id' => "IOzLLH4SETAMacFs2ITXJc5uOY0PJ70Ws9VDFyXk", 'X-Parse-REST-API-Key' => "yUIwUBNG9INsEDCG5HjVS9uw0QsddPdshPKonSAK"
    end
  end

  def self.cupon_notify(iphone_id)
    if (Notification.user_signout(iphone_id))
      respond = RestClient.post "https://api.parse.com/1/push", {:where => {:channels=> iphone_id}, :data => {:alert => "Acabas de recibir un cupon, entra en tus cupones y disfruta!"}}.to_json, :content_type => :json, :accept => :json, 'X-Parse-Application-Id' => "IOzLLH4SETAMacFs2ITXJc5uOY0PJ70Ws9VDFyXk", 'X-Parse-REST-API-Key' => "yUIwUBNG9INsEDCG5HjVS9uw0QsddPdshPKonSAK"
    end
  end

  def self.shared_notify (sender_id, reciever_id)
    if (Notification.user_signout_id(reciever_id))
    	reciever = User.find_by(user_uid: reciever_id)
    	sender = User.find_by(user_uid: sender_id)
    	message = sender.name + " acaba de compartir un cupon contigo!"
    	respond = RestClient.post "https://api.parse.com/1/push", {:where => {:channels=> reciever.iphone_id}, :data => {:alert => message}}.to_json, :content_type => :json, :accept => :json, 'X-Parse-Application-Id' => "IOzLLH4SETAMacFs2ITXJc5uOY0PJ70Ws9VDFyXk", 'X-Parse-REST-API-Key' => "yUIwUBNG9INsEDCG5HjVS9uw0QsddPdshPKonSAK"
    end
  end

  def self.fb_notify(sender_id, reciever_id, cupon_id,venue_id)
    user=User.find_by(user_uid: sender_id)
    graph = Koala::Facebook::API.new(user.fb_token)
    venue = Venue.where(:venue_id => venue_id).last
    caption = "Utiliza este cupon en tu proxima visita a " + venue.name
    url = "http://coupon.thanxup.com/cupon/"+cupon_id
    graph.put_wall_post("Hey, acabo de pasarte un cupon a traves de #ThanxUp! :)", {"place" => venue.place_id,"tags" => reciever_id, "application" => "195410900598304", "link" => url, "name" => "ThanxUp Social Coupon", "caption" => caption, "picture" => "https://dl.dropboxusercontent.com/u/4248143/cupon.png"})
  end

  def self.user_signout(iphone_token)
    user = User.find_by(iphone_id: iphone_token)
    return user.notify
  end

  def self.user_signout_id(reciever_id)
    user = User.find_by(user_uid: reciever_id)
    return user.notify
  end

end
