class Cupon
  include Mongoid::Document
  include Mongoid::Timestamps
  field :store_id, type: String
  field :owner_id, type: String
  field :cupon_id, type: String
  field :expiration_date, type: Date
  belongs_to :venue
end
