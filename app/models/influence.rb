class Influence

	def self.basicFacebookData(uid,graph)
	 	user=User.find_by(user_uid: uid)
	  profile = graph.get_object("me")
	  user.email = profile["email"]
	  user.name = profile["name"]
	  user.location_name = profile["location"]["name"]
	  user.location_id = profile["location"]["id"]
	  user.DOB = Date.strptime(profile["birthday"], '%m/%d/%Y')

	  #get_friends
	  friends = Array.new
	  graph.get_connections("me","friends",:fields =>"id").each do |x|
	    friends << x["id"]
	  end

	  user.fb_friends = friends
	  num = graph.fql_query("SELECT friend_count FROM user WHERE uid = me()")
	  user.friend_count = num.first["friend_count"]
	  user.save

	end


  def self.getWeeklyLikes(graph)
  	since = (Time.now - 7.days).to_i
  	total_likes = 0
  	feed = graph.fql_query("SELECT post_id ,likes FROM stream WHERE source_id=me() AND created_time >" + since.to_s)
  	feed.each do |x|
  		unless x["likes"]["count"].nil?
  			total_likes += x["likes"]["count"]
  		end
  	end
   	return total_likes
  end

  def self.getShares(user)
  end

  def self.getFriendCupons(user)

  end



end
