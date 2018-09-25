class ChartLine
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :series

  field :time, type: DateTime
  field :value, type: Float

  def self.process data
    logger.info "processing: #{data}"

    serial = data['header']['serial_number']
    time = data['header']['timestamp']
    gw = Gateway.find_or_create_by(serial_number: serial)
    meter_data = data['meter_data']
    process_ts(gw, time, meter_data,['acb','current',0], "acb_current_0")
    process_ts(gw, time, meter_data,['acb','voltage',0], "acb_voltage_0")
  end

  def self.process_ts(gw, time, data, dig_array, ts_name)
    value = data.dig(*dig_array)
    ts = TsName.find_or_create_by(name: ts_name)
    series = Series.find_or_create_by(gateway_id: gw.id, ts_name_id: ts.id)
    cd = ChartLine.create(time: time, value: value, series_id: series)
    logger.info "chart_data created"
  end

end
