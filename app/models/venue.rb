class Venue
  include Mongoid::Document
  include Mongoid::Timestamps
  field :venue_id, type: String
  field :name, type: String
  field :web, type: String
  field :fb_page, type: String
  field :place_id, type: String
  field :contact_name, type: String
  field :email, type: String
  field :passcode, type: String
  field :image_link, type: String
  field :address, type: String
  field :latitude, type: String
  field :longitude, type: String
  embeds_many :offers
  embeds_many :venue_visits

  index({venue_id: 1}, {unique: true, background: true})



end
