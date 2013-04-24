class Visit
  include Mongoid::Document
  include Mongoid::Timestamps
  field :venue_id, type: String
  field :shared,   type: Boolean
  belongs_to :user
end
