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

  field :social_text, type: String
  field :social_count, type: Integer, default: ""
  field :social_limit, type: Integer
  field :social_offer, type: String
  field :social_from, type: Date
  field :social_until, type: Date
  embedded_in :offer
end
