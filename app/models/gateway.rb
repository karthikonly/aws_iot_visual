class Gateway
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :series

  field :serial_number, type: String
end
