class Influence

#Time consideration: Saved in UTC, 00:01 Mad time = 21:01 UTC
#Run rake at 23:30 UTC Sunday => 01:30 MAD monday


#On sundays:
#1. Create new weekly (blank)
#2. Calculate influence for end of week activity, update end-of week record (created 1weekago)
#3. End of week influence to user profile.

	def self.basicFacebookData(uid,graph)
	 	user=User.find_by(user_uid: uid)
	  profile = graph.get_object("me")
	  user.email = profile["email"]
	  user.name = profile["name"]
    user.gender = profile["gender"]
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
	#  friends = Array.new
	 # graph.get_connections("me","friends",:fields =>"id").each do |x|
	  #  friends << x["id"]
	 # end
    feed = graph.fql_query("SELECT friend_count FROM user WHERE uid = " + uid)
	  user.friend_count = feed[0]["friend_count"]
	  user.save

	end

	def self.update_info_recal_influence(user_id)
    user = User.find_by(user_uid: user_id)
    graph = Koala::Facebook::API.new(user.fb_token)

    #Get fresh basic user info
    Influence.basicFacebookData(user_id,graph)

    #Calculate influence
    likes = Influence.getWeeklyLikes(graph)
    likes_per_day = likes/7.to_f
    friends = (user.friend_count)/100.to_f

    #Get tags
    tags = Influence.getWeeklyTags(graph)
    tags_per_day = tags/7.to_f

    weighted_likes = (1- Math.exp(-0.795*likes_per_day))
    weighted_friends = (1- Math.exp(-0.795*friends))
    weighted_tags = (1- Math.exp(-1.35*tags_per_day))

    if (user.weeklies.count == 0)
      user.weeklies.push(Weekly.new)
      user.influence = weighted_likes*0.4 + weighted_tags*0.3 + weighted_friends*0.3
      user.save
    else
      #  calc_influence   calculate real influence based on last week
      end_week = user.weeklies.ascending(:created_at).last

      weighted_cupon_share = (1- Math.exp(-0.95*(end_week.shared_cupons/7.to_f)))
      weighted_cupon_redeem = (1- Math.exp(-1.2*(end_week.consumed_ff_cupons/7.to_f)))

      call_to_action = 0.6*(weighted_cupon_share*0.35 + weighted_cupon_redeem*0.65)
      passive_influence = 0.4*(weighted_likes*0.4 + weighted_tags*0.3 + weighted_friends*0.3)
      puts passive_influence/0.4
      end_week.influence = passive_influence + call_to_action
      user.influence = passive_influence + call_to_action
      user.save
      end_week.save
      user.weeklies.push(Weekly.new)
    end

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
    if total_likes.nil? 
      return 0
    else
      return total_likes
    end
  end

  def self.getWeeklyTags(graph)
    since = (Time.now - 7.days).to_i 
    feed = graph.fql_query("SELECT post_id, actor_id, target_id, message FROM stream WHERE filter_key = 'others' AND source_id = me() AND created_time >" + since.to_s)
    if feed.count.nil? 
      return 0
    else
      return feed.count
    end
  end

  def self.getShares(user_id)
    user=User.find_by(user_uid: uid)
    time = DateTime.now.utc - 1.week
    shares = user.visits.where(:created_at.gte => time).where(:shared => true).count
    #Weekly.ascending(:created_at).last => newest!
    if shares.nil? 
      return 0 
    else
      return shares
    end
  end

  def self.getcuponshares(used_id)
    user=User.find_by(user_uid: uid)
    return user.weeklies.ascending(:created_at).last.shared_cupons
  end


  def self.getFriendCupons(user)
    user=User.find_by(user_uid: uid)
    return user.weeklies.ascending(:created_at).last.consumed_ff_cupons

  end

  def self.weekly
    users = User.all
    users.each do |x|
      begin 
        Influence.update_info_recal_influence(x.user_uid)
      rescue => e
        puts "User "+x.user_uid+"not valid fb id"
      end
      sleep(3)
    end
  end

end
