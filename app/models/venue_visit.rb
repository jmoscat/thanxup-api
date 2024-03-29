class VenueVisit
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_fb_id,   type: String
  field :venue_id, type: String
  field :venue_raw_id, type: String
  field :visit_count, type: Integer
  field :user_influence, type: Float
  field :shared, type: Boolean
  belongs_to :venue
end
