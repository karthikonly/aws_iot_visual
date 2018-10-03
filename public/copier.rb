require 'yaml'
require 'json'
require 'mqtt'

def load_config
  $config = YAML::load_file('client_config.yaml')
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
  $source_stream = $config['mqtt']['source_stream']
  $destination_stream = $config['mqtt']['destination_stream']
  # pp $client
end

def daemonize
  Process.daemon()
  STDOUT.reopen $config['connect']['log_file'], "a"
  STDERR.reopen $config['connect']['log_file'], "a"
  # pp Dir.pwd
end

def copy_loop
  $client.subscribe($source_stream => 1)
  puts "#{Time.now} started listening to: #{$source_stream}"

  $client.get do |topic, message|
    puts "#{Time.now} republished message of size: #{message.size}: #{message}"
    $client.publish($destination_stream, message, retain = false, qos = 1)
  end
end

def main
  load_config
  # daemonize
  loop do
    begin
      init_mqtt_client
      copy_loop
    rescue => e
      STDERR.puts "#{Time.now} Exception caught: #{e}. Continuuing again."
    end
  end
end

main
