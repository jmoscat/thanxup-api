class Offer
  include Mongoid::Document
  include Mongoid::Timestamps
  field :offer_id, type: String
  field :offer_text, type: String
  field :fb_post, type: String
  field :valid_from, type: DateTime
  field :valid_until, type: DateTime
  
  field :influence_1, type: Float
  field :action_1, type: String
  field :info_1, type: String

  field :influence_2, type: Float
  field :action_2, type: String
  field :info_2, type: String
  
  field :influence_3, type: Float
  field :action_3, type: String
  field :info_3, type: String
  embeds_many :cupon_templates
  belongs_to :venue


end
