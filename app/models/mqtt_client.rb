class MqttClient
  attr_accessor :mqtt_client, :data_stream_topic, :logger

  def initialize(config={})
    @logger = Logger.new(STDOUT)
    client = MQTT::Client.new
    client.host = config[:aws_mqtt_endpoint]
    client.port = 8883
    client.ssl = true
    client.cert_file = config[:cert_file]
    client.key_file  = config[:key_file]
    client.ca_file   = config[:ca_file]
    client.connect
    @data_stream_topic = config[:data_stream_topic]
    @response_stream_topic_prefix = config[:response_stream_prefix]
    @mqtt_client = client
  end

  def process_messages
    mqtt_client.subscribe(data_stream_topic => 1)
    logger.info "started listening to: #{data_stream_topic}"

    mqtt_client.get do |topic, message|
      process_each_message(topic, JSON.parse(message))
    end
  end

  def process_each_message(topic, data)
    serial = data['serial_number']
    return unless serial
    $redis.hmset serial, :timestamp, Time.now.to_s
    ChartData.process(data)
  end
end