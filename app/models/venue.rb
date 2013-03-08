class Venue
  include Mongoid::Document
  include Mongoid::Timestamps
  field :venue_id, type: String
  field :name, type: String
  field :web, type: String
  field :fb_page, type: String
  field :contact_name, type: String
  field :email, type: String
  field :passcode, type: String
  field :image_link, type: String
  field :address, type: String
  field :latitude, type: String
  field :longitude, type: String
  embeds_many :offers

end
