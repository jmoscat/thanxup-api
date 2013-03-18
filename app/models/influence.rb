class Influence

	def self.basicFacebookData(uid,graph)
	 	user=User.find_by(user_uid: uid)
	  profile = graph.get_object("me")
	  user.email = profile["email"]
	  user.name = profile["name"]
    location = profile["location"]
    if location.nil?
      user.location_name = ""
      user.location_id = ""
    else
      user.location_name = location["name"]
	    user.location_id = location["id"]
    end

    if profile["birthday"].nil?
      user.DOB = ""
    else
      user.DOB = Date.strptime(profile["birthday"], '%m/%d/%Y')
    end
    
	  #get_friends
	  friends = Array.new
	  graph.get_connections("me","friends",:fields =>"id").each do |x|
	    friends << x["id"]
	  end

	  user.fb_friends = friends
	  user.friend_count = friends.count
	  user.save

	end

	def self.update_info_recal_influence(user_id)
    user = User.find_by(user_uid: user_id)
    graph = Koala::Facebook::API.new(user.fb_token)

    #Get fresh basic user info
    Influence.basicFacebookData(user_id,graph)

    #Calculate influence
    likes = Influence.getWeeklyLikes(graph)
    likes_per_day = likes/7.0
    friends = (user.friend_count)/100.0

    #Get tags
    tags = Influence.getWeeklyTags(graph)
    tags_per_day = tags/7.0

    weighted_likes = (1- Math.exp(-0.795*likes_per_day))
    weighted_friends = (1- Math.exp(-0.795*friends))
    weighted_tags = (1- Math.exp(-1.35*tags_per_day))

    user.influence = weighted_likes*0.4 + weighted_tags*0.3 + weighted_friends*0.3
    user.save

    #Push notificiation for new influence!

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

  def self.getWeeklyTags(graph)
    since = (Time.now - 7.days).to_i 
    feed = graph.fql_query("SELECT post_id, actor_id, target_id, message FROM stream WHERE filter_key = 'others' AND source_id = me() AND created_time >" + since.to_s)
    return feed.count
  end

  def self.getShares(user)
  end

  def self.getFriendCupons(user)

  end



end
