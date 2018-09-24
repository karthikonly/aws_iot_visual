class Series
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :chart_data

  field :serial_number, type: String
  field :name, type: String
end
