class Notification
  def self.influence_notify(user_id, influence)
  	 respond = RestClient.post "https://api.parse.com/1/push", {:where => {:channels=> phone_id}, :data => {:alert => "Nueva influencia"}}.to_json, :content_type => :json, :accept => :json, 'X-Parse-Application-Id' => "IOzLLH4SETAMacFs2ITXJc5uOY0PJ70Ws9VDFyXk", 'X-Parse-REST-API-Key' => "yUIwUBNG9INsEDCG5HjVS9uw0QsddPdshPKonSAK"
  end

  def self.shared_notify (sender_name, reciever_id)
  end

  def self.fb_notify(friends,cupons,sender_id, venue_id)
  	user=User.find_by(user_uid: sender_id)
  	graph = Koala::Facebook::API.new(user.fb_token)
  	venue = Venue.where(:venue_id => venue_id).last
  	friends.each_with_index do |x, i|
  		url = "http://coupon.thanxup.com/cupon/"+cupons[i]
			graph.put_wall_post("Hey, acabo de pasarte un cupon a traves de ThanxUp! :)", {"place" => venue.place_id,"tags" => x, "application" => "195410900598304", "link" => url, "name" => "ThanxUp Social Coupon"})
		end
  end

end
