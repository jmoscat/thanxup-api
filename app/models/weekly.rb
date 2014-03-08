class Weekly
  include Mongoid::Document
  include Mongoid::Timestamps
  field :influence, type: Float, default: 0.0
  field :shared_cupons, type: Integer,  default: 0
  field :new_cupons, type: Integer, default: 0
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

  def addcupon
    self.new_cupons = self.new_cupons + 1
    self.save
  end
  
end