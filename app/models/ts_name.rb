class TsName
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :series

  field :name, type: String
end
