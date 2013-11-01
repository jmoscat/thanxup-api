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


    friends = (user.friend_count.to_f)/100.to_f

    #Get tags
    tags = Influence.getWeeklyTags(graph)
    tags_per_day = tags/7.to_f


    weighted_likes = (1- Math.exp(-0.795*likes_per_day))
    weighted_friends = (1- Math.exp(-0.795*friends))
    weighted_tags = (1- Math.exp(-1.35*tags_per_day))



    if (user.weeklies.count == 0)
      user.weeklies.push(Weekly.new)
      #0.7 to reduce a little bit original influence
      user.influence = 0.75*(weighted_likes*0.35 + 0.0*0.25 +weighted_tags*0.25 + weighted_friends*0.15) 
      user.save
      respond = RestClient.post "https://api.parse.com/1/push", {:where => {:channels=> user.iphone_id}, :data => {:alert => "Your influence has been calculated!"}}.to_json, :content_type => :json, :accept => :json, 'X-Parse-Application-Id' => "IOzLLH4SETAMacFs2ITXJc5uOY0PJ70Ws9VDFyXk", 'X-Parse-REST-API-Key' => "yUIwUBNG9INsEDCG5HjVS9uw0QsddPdshPKonSAK"

    else
      #need to check for only one week past
      week4 = user.weeklies.descending(:created_at).limit(4)
      count_weeks = week4.count(true)
      end_week = week4[0]
      old_comp_influence = user.influence

      #Cupons
      weighted_cupon_share = (1- Math.exp(-0.95*(end_week.shared_cupons/7.to_f)))
      weighted_cupon_redeem = (1- Math.exp(-1.2*(end_week.consumed_ff_cupons/7.to_f)))

      #Get checkins
      checkins = user.visits.where(:created_at.gt => (Time.now.utc - 7.days)).count(true)
      checkins_per_day = checkins/7.to_f
      weighted_checkins = (1- Math.exp(-4.6*checkins_per_day))
      if(friends < 20)
        weighted_checkins_pond = weighted_checkins*0.5
      else
        weighted_checkins_pond = weighted_checkins*(user.friend_count/200.0)
      end

      call_to_action = 0.30*(weighted_cupon_share*0.35 + weighted_cupon_redeem*0.65)
      passive_influence = 0.70*(weighted_likes*0.35 + weighted_checkins_pond*0.25 +weighted_tags*0.25 + weighted_friends*0.15) 

      week_influence = (passive_influence + call_to_action)
      total = week_influence

      if (count_weeks > 1) #If more than one week
        (1..(count_weeks - 1)).each do |i| # take all except the newest weekly
          total =  total.to_f + week4[i]["influence"]
        end
        average_influence = total/count_weeks.to_f
      else #During the first week do not change influence daily until first sunday
        average_influence = (old_comp_influence + total)/2.0
      end

      #----------------------------------------------#
      #DEV, do not chage influence unless increase
      if (average_influence > old_comp_influence)
        average_influence = average_influence
      else
        average_influence = old_comp_influence
      end
      #----------------------------------------------#

      if Time.now.monday?
        end_week.influence = average_influence
        end_week.save
        user.weeklies.push(Weekly.new)
      end

      user.influence = average_influence
      user.save

      if (average_influence > old_comp_influence)
        return true
      else
        return false
      end
    end
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
    user=User.find_by(user_uid: user_id)
    time = DateTime.now.utc - 1.week
    shares = user.visits.where(:created_at.gte => time).where(:shared => true).count(true)
    #Weekly.ascending(:created_at).last => newest!
    if shares.nil? 
      return 0 
    else
      return shares
    end
  end

  def self.getcuponshares(used_id)
    user=User.find_by(user_uid: used_id)
    return user.weeklies.ascending(:created_at).last.shared_cupons
  end


  def self.getFriendCupons(user_id)
    user=User.find_by(user_uid: user_id)
    return user.weeklies.ascending(:created_at).last.consumed_ff_cupons

  end

  def self.daily 
    new_logger = Logger.new('log/influence.log')
    new_logger.info("DAILY RUTINE- "+ Time.now.to_s+ " ")
    User.each do |x|
      if x.active
        begin
          if (Influence.update_info_recal_influence(x.user_uid))
            Notification.influence_notify(x.iphone_id)
          end
          new_logger.info("\t SUCCESS: "+ x.user_uid)
        rescue => e
          new_logger.info("\t FAILED: "+ x.user_uid)
        end
      end
      sleep(3)
    end
  end
end
