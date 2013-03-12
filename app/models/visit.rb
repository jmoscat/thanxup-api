class Visit
  include Mongoid::Document
  include Mongoid::Timestamps
  field :venue_id, type: String
  field :shared,   type: Boolean
  embedded_in :user
end
