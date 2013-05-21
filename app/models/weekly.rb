class Weekly
  include Mongoid::Document
  include Mongoid::Timestamps
  field :influence, type: Float
  field :shared_cupons, type: Integer,  default: 0
  field :consumed_ff_cupons, type: Integer, default: 0
  belongs_to :user

  def addShared(count)
  	self.shared_cupons = self.shared_cupons + count.to_i
  	self.save
  end

  def consumed(count)
  	self.consumed_ff_cupons = self.consumed_ff_cupons + count.to_i
  	self.save
  end
end