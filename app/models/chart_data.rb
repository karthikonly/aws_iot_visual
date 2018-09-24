class ChartData
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :series

  field :time, type: DateTime
  field :value, type: Float

  def self.process data
    logger.info "processing: #{data}"
  end

end
