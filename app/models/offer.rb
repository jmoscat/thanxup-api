class Offer
  include Mongoid::Document
  include Mongoid::Timestamps
  field :offer_id, type: String 
  field :offer_kind, type: String # 1 discount 2 gift
  field :offer_text, type: String
  field :fb_post, type: String

  #offer_kind 1
  field :discount_max, type: Float
  field :discount_thing, type: String

  #offer_kind 2
  field :gift_min_inf, type: Float
  field :gift_thing, type: String

  #cupon_data
  field :kind, type: String   #IND/ SHA
  field :cupon_text, type: String, default: ""
  field :cupon_valid_from, type: DateTime
  field :cupon_valid_until, type: DateTime

  field :social_text, type: String, default: ""
  field :social_count, type: Integer, default: ""
  field :social_limit, type: Integer, default: ""
  field :social_from, type: DateTime, default: ""
  field :social_until, type: DateTime, default: ""
  belongs_to :venue

  def getOffer
    if self.offer_kind == "1"
      offer_respond = {
      :status => "1",
      :offer_kind => self.offer_kind, 
      :offer_text => self.offer_text, 
      :fb_post => self.fb_post,
      :discount_max => self.discount_max,
      :discount_thing => self.discount_thing,
      :kind => self.kind,
      :cupon_text => self.cupon_text,
      :cupon_valid_from => self.cupon_valid_from.strftime("%d-%m-%Y"),
      :cupon_valid_until => self.cupon_valid_until.strftime("%d-%m-%Y"),
      :social_text => self.social_text,
      :social_from => self.social_from.strftime("%d-%m-%Y"),
      :social_until => self.social_until.strftime("%d-%m-%Y")
      }
    elsif self.offer_kind == "2"
      offer_respond = {
      :status => "1",
      :offer_kind => self.offer_kind, 
      :offer_text => self.offer_text, 
      :fb_post => self.fb_post,
      :gift_min_inf => self.gift_min_inf,
      :kind => self.kind,
      :cupon_text => self.cupon_text,
      :cupon_valid_from => self.cupon_valid_from.strftime("%d-%m-%Y"),
      :cupon_valid_until => self.cupon_valid_until.strftime("%d-%m-%Y"),
      :social_text => self.social_text,
      :social_from => self.social_from.strftime("%d-%m-%Y"),
      :social_until => self.social_until.strftime("%d-%m-%Y")
      }
    end
    return offer_respond.to_json
  end

  def self.setOffer (params)
    offer = Venue.find_by(venue_id: params[:venue_id]).offers.first
    venue = Venue.find_by(venue_id: params[:venue_id])
    new_offer = Offer.new
    new_offer.offer_kind = params["offer_kind"]
    new_offer.fb_post = params["fb_post"]
    if params["offer_kind"] == "1"
      new_offer.offer_text = "Hasta " + (params["discount_max"].to_f).round.to_s + "% de descuento en " + params["discount_thing"].downcase + " segun tu influencia"
      new_offer.discount_max = (params["discount_max"].to_f)/100.0
      new_offer.discount_thing = params["discount_thing"]
    elsif params["offer_kind"] == "2"
      if params["gift_thing"].include?("gratis")
        new_offer.offer_text = params["gift_thing"] + " a partir de " + params["gift_min_inf"] + "% de influencia"
        new_offer.cupon_text = params["gift_thing"]
      else
        new_offer.offer_text = params["gift_thing"] + " gratis" + " a partir de " + (params["gift_min_inf"].to_f).round.to_s  + "% de influencia"
        new_offer.cupon_text = params["gift_thing"] + " gratis"
      end
      new_offer.gift_min_inf = (params["gift_min_inf"].to_f)/100.0
      new_offer.gift_thing = params["gift_thing"]
    end

    new_offer.cupon_valid_from = (params["cupon_valid_from"].to_datetime + 1.day - 1.second).utc
    new_offer.cupon_valid_until = (params["cupon_valid_until"].to_datetime + 1.day - 1.second).utc
    if (params["social"]["1"] == "0") or (params["social"]["2"] == "0")
      new_offer.kind = "IND"
      # need to set dummy years for strftimes format in GET
      new_offer.social_from = (DateTime.now - 200.years).utc
      new_offer.social_until = (DateTime.now + 10.years).utc
    elsif (params["social"]["1"] == "1") or (params["social"]["2"] == "1")
      new_offer.kind = "SHA"
      new_offer.social_count = 0
      new_offer.social_limit = 3
      new_offer.social_text = params["social_text"]
      new_offer.social_from = (params["social_from"].to_datetime + 1.day - 1.second).utc
      new_offer.social_until = (params["social_until"].to_datetime + 1.day - 1.second).utc
    end
    venue.offers.push(new_offer)
    status = venue.save

    if status 
      if !offer.nil?
        offer.delete
      end
      return "1"
    else
      return "0"
    end

  end


end
