require 'yaml'
require 'json'
require 'mqtt'

$template = {
  "header": {
    "timestamp": "2018-09-19 11:51:32 PDT",
    "report_seq_num": 1,
    "serial_number": "0000000000",
    "report_version": "00.01",
    "software_version": "e2gw-00.00.01-m",
    "system_type": "EnsembleProto"
  },
  "meter_data": {
    "acb": {
      "current": [-131.2, -132.2, -133.2],
      "PE-": [-108.2, -109.2, -110.2],
      "QE+": [-112.2, -113.2, -114.2],
      "QE-": [0, 0, 0],
      "Q": [-124.2, -125.2, -126.2],
      "P": [105.1, 106.1, 107.1],
      "S": [-128.2, -129.2, -130.2],
      "frequency": 116.1,
      "PF": [-120.2, -121.2, -122.2],
      "voltage": [109.1, 110.1, 111.1],
      "PE+": [-103.2, -104.2, -105.2],
      "SE": [-116.2, -117.2, -118.2]
    },
    "pv": {
      "current": [-131.2, -132.2, -133.2],
      "PE-": [-108.2, -109.2, -110.2],
      "QE+": [-112.2, -113.2, -114.2],
      "QE-": [0, 0, 0],
      "Q": [-124.2, -125.2, -126.2],
      "P": [105.1, 106.1, 107.1],
      "S": [-128.2, -129.2, -130.2],
      "frequency": 116.1,
      "PF": [-120.2, -121.2, -122.2],
      "voltage": [109.1, 110.1, 111.1],
      "PE+": [-103.2, -104.2, -105.2],
      "SE": [-116.2, -117.2, -118.2]
    }
  },
  "system": {
    "last_restart_time": "2018-09-19 11:41:22 PDT",
    "pv_nameplate_w": 7400,
    "acb_nameplate_w": 1600
  }
}

def load_config
  $config = YAML::load_file('client_config.yaml')
  $config['connect']['serial_number'] = '0200' #ARGV[0] || SecureRandom.urlsafe_base64(6)
  $config['connect']['full_working_path'] = $config['connect']['directory']
  Dir.chdir($config['connect']['full_working_path'])
  # pp $config
  # pp Dir.pwd
end

def init_mqtt_client
  serial = $config['connect']['serial_number']
  client = MQTT::Client.new
  client.host = $config['mqtt']['aws_mqtt_endpoint']
  client.port = 8883
  client.ssl = true
  client.cert_file = "#{serial}-cert.pem"
  client.key_file  = "#{serial}-private.key"
  client.ca_file   = $config['mqtt']['ca_file_path']
  client.connect
  $client = client
  # pp $client
end

def message_loop
  while true
    $template[:header][:serial_number] = $config['connect']['serial_number']
    $template[:header][:report_seq_num] += 1
    $template[:header][:timestamp] = Time.now.to_s
    data = $template.to_json
    $client.publish($config['mqtt']['data_stream'], data, retain = false, qos = 1)
    p "published data: #{data}"
    sleep 5
  end
end

def main
  load_config
  init_mqtt_client
  message_loop
end

main
