class Offer
  include Mongoid::Document
  include Mongoid::Timestamps
  field :offer_id, type: String
  field :offer_text, type: String
  field :fb_post, type: String
  field :valid_from, type: DateTime
  field :valid_until, type: DateTime
  
  field :influce_1, type: Float
  field :action_1, type: String
  field :info_1, type: String

  field :influce_2, type: Float
  field :action_2, type: String
  field :info_2, type: String
  
  field :influce_3, type: Float
  field :action_3, type: String
  field :info_3, type: String
  embedded_in :venue


end
