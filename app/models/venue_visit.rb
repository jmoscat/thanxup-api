class VenueVisit
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_fb_id,   type: String
  field :shared, type: Boolean
  embedded_in :venue
end
