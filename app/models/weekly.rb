class Weekly
  include Mongoid::Document
  include Mongoid::Timestamps
  field :influence, type: Float
  field :shared_cupons, type: Integer
  field :consumed_ff_cupons, type: Integer
  belongs_to :user
end


def addShared
	self.shared_cupons = self.shared_cupons + 1
	self.save
end

def consumed_ff_cupons
	self.consumed_ff_cupons = self.consumed_ff_cupons + 1
	self.save
end