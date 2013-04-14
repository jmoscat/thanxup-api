class CuponTemplate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :template_id, type: String #1,2,3
#  field :store_id, type: String,  default: ""
 # field :user_fb_id, type: String, default: ""
  field :parent_cupon, type: String, default: ""
# Cupon info
	field :cupon_text, type: String
	field :valid_from, type: DateTime
  field :valid_until, type: DateTime


#SHARABLE/ CONSUMIBLE / INDIVIDUAL
  field :kind, type: String  

# Sharable information

  field :sharable_text, type: String
  field :shared_count, type: Integer, default: ""
  field :sharable_limit, type: Integer
  field :sharable_offer, type: String
  field :sharable_from, type: Date
  field :sharable_to, type: Date

# Consumible information
	field :consumible_text, type: String
  field :consumed_count, type: Integer, default: ""
  field :consumible_limit, type: Integer
  field :consumible_offer, type: String
  field :consumible_from, type: Date
  field :consumible_to, type: Date
  embedded_in :offer
end
