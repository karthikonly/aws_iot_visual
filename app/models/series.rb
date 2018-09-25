class Series
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :chart_lines

  belongs_to :gateway
  belongs_to :ts_name
end
