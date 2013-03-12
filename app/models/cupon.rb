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
	field :expiration_date, type: Date

# Sharable information
  field :sharable, type: Boolean
  field :shared_count, type: Integer
  field :sharable_limit, type: Integer
  field :sharable_offer, type: String
  field :sharable_from, type: Date
  field :sharable_to, type: Date

# Consumible information
	field :consumible, type: Boolean
  field :consumed_count, type: Integer
  field :consumible_limit, type: Integer
  field :consumible_offer, type: String
  field :consumible_from, type: Date
  field :consumible_to, type: Date
  
  index({cupon_id: 1}, {unique: true, background: true})


  def self.secure_hash (string)
    Digest::SHA2.hexdigest(string)
  end


end
