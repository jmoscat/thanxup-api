class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  field :yo, type: String
  field :x, type: String, default: "" #lat
  field :y, type: String, default: "" #lon

  def self.create_new(fb_uid, lat, lon)
  	loc = Location.new
  	loc.yo = fb_uid
  	loc.x = lat
  	loc.y = lon
  	loc.save
  end
end
