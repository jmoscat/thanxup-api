class Notification
  def self.influence_notify(iphone_id)
    #, :badge => "1"
  	 respond = RestClient.post "https://api.parse.com/1/push", {:where => {:channels=> iphone_id}, :data => {:alert => "Tu influencia ha aumentado, yeeah!!"}}.to_json, :content_type => :json, :accept => :json, 'X-Parse-Application-Id' => "IOzLLH4SETAMacFs2ITXJc5uOY0PJ70Ws9VDFyXk", 'X-Parse-REST-API-Key' => "yUIwUBNG9INsEDCG5HjVS9uw0QsddPdshPKonSAK"
     puts respond
  end

  def self.shared_notify (sender_id, reciever_id)
  	reciever = User.find_by(user_uid: reciever_id)
  	sender = User.find_by(user_uid: sender_id)
  	message = sender.name + " acaba de compartir un cupon contigo!"
  	respond = RestClient.post "https://api.parse.com/1/push", {:where => {:channels=> reciever.iphone_id}, :data => {:alert => message}}.to_json, :content_type => :json, :accept => :json, 'X-Parse-Application-Id' => "IOzLLH4SETAMacFs2ITXJc5uOY0PJ70Ws9VDFyXk", 'X-Parse-REST-API-Key' => "yUIwUBNG9INsEDCG5HjVS9uw0QsddPdshPKonSAK"
  end

  def self.fb_notify(sender_id, reciever_id, cupon_id,venue_id)
    user=User.find_by(user_uid: sender_id)
    graph = Koala::Facebook::API.new(user.fb_token)
    venue = Venue.where(:venue_id => venue_id).last
    url = "http://coupon.thanxup.com/cupon/"+cupon_id
    graph.put_wall_post("Hey, acabo de pasarte un cupon a traves de ThanxUp! :)", {"place" => venue.place_id,"tags" => reciever_id, "application" => "195410900598304", "link" => url, "name" => "ThanxUp Social Coupon"})
  end

end
