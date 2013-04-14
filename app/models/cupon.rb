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
  
  index({user_fb_id: 1})
  index({ _id: 1}, { unique: true })


  def self.secure_hash (string)
    Digest::SHA2.hexdigest(string)
  end

  def self.cupon_from_template(template,user_id, venue_id)
    new_cupon = Cupon.new
    new_cupon.cupon_id = secure_hash( "#{new_cupon._id}"+"#{user_id}"+ DateTime.now.to_s)
    new_cupon.store_id = venue_id
    new_cupon.user_fb_id = user_id
    new_cupon.parent_cupon = ""
    new_cupon.used = false
    new_cupon.cupon_text = template.cupon_text
    new_cupon.valid_from = template.valid_from
    new_cupon.valid_until = template.valid_until

    if template.kind == "SHARABLE"
      new_cupon.kind = "SHARABLE"
      new_cupon.sharable_text = template.sharable_text
      new_cupon.shared_count = template.shared_count
      new_cupon.sharable_limit = template.sharable_limit
      new_cupon.sharable_from  = template.sharable_from
      new_cupon.sharable_to  = template.sharable_to

    elsif template.kind == "CONSUMIBLE"
      new_cupon.kind = "CONSUMIBLE"
      new_cupon.consumible_text = template.consumible_text
      new_cupon.consumed_count = template.consumed_count
      new_cupon.consumible_limit = template.consumible_limit
      new_cupon.consumible_from  = template.consumible_from
      new_cupon.consumible_to  = template.consumible_to
    end
    new_cupon.save
  end

  def self.getCupons(user_id)
    return Cupon.where(user_fb_id: user_id, used: false).to_json(:only => [ :_id, :store_id, :cupon_text, :valid_from, :valid_until, :kind ])
  end


end
