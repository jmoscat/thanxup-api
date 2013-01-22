class Visit
  include Mongoid::Document
  include Mongoid::Timestamps
  field :store_id, type: String
  field :shared,   type: Boolean
end
