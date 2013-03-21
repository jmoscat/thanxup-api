require 'digest'

class Cupon
  include Mongoid::Document
  include Mongoid::Timestamps
  field :cupon_id, type: String
  field :store_id, type: String
  field :user_fb_id, type: String
  field :parent_cupon, type: String
# Cupon info
	field :cupon_text, type: String
	field :valid_from, type: DateTime
  field :valid_until, type: DateTime
  field :used, type: Boolean

#
  field :kind, type: String 

# Sharable information
  field :sharable_text, type: String
  field :shared_count, type: Integer
  field :sharable_limit, type: Integer
  field :sharable_offer, type: String
  field :sharable_from, type: Date
  field :sharable_to, type: Date

# Consumible information
	field :consumible_text, type: String
  field :consumed_count, type: Integer
  field :consumible_limit, type: Integer
  field :consumible_offer, type: String
  field :consumible_from, type: Date
  field :consumible_to, type: Date
  
  index({ _id: 1, user_fb_id: 1 }, { unique: true })


  def self.secure_hash (string)
    Digest::SHA2.hexdigest(string)
  end

  def self.cupon_from_offer(offer,user_id, venue_id)
    new_cupon = Cupon.new
    new_cupon.cupon_id = secure_hash( "#{new_cupon._id}"+"#{user_id}"+ DateTime.now.to_s)
    new_cupon.store_id = venue_id
    new_cupon.user_fb_id = user_id
    new_cupon.parent_cupon = ""
    new_cupon.used = false
    new_cupon.cupon_text = offer.offer_text
    new_cupon.valid_from = offer.valid_from
    new_cupon.valid_until = offer.valid_until

    if offer.kind == "SHARABLE"
      new_cupon == "SHARABLE"
      new_cupon.sharable = offer.sharable
      new_cupon.sharable_text = offer.sharable_text
      new_cupon.shared_count = offer.shared_count
      new_cupon.sharable_limit = offer.sharable_limit
      new_cupon.sharable_offer = offer.sharable_offer
      new_cupon.sharable_from  = offer.sharable_from
      new_cupon.sharable_to  = offer.sharable_to

    elsif offer.kind == "CONSUMIBLE"
      new_cupon.kind = "CONSUMIBLE"
      new_cupon.consumible = offer.consumible
      new_cupon.consumible_text = offer.consumible_text
      new_cupon.consumed_count = offer.consumed_count
      new_cupon.consumible_limit = offer.consumible_limit
      new_cupon.consumible_offer = offer.consumible_offer
      new_cupon.consumible_from  = offer.consumible_from
      new_cupon.consumible_to  = offer.consumible_to
    end
  end
  



end
