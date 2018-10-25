require 'json'
require 'date'

def main
  data = {}
  data[:site_id] = rand.to_s[2..10]
  start_time = Date.today.to_time
  data[:battery_state] ||= []
  25.times do
    data[:battery_state] << { timestamp: start_time.to_s, power: rand(500..800), charge_state: rand(0..100) }
    start_time += 60*60
  end
  data[:battery_charge_time] ||= []
  25.times do
    data[:battery_charge_time] << { start_hour: start_time.to_s, charge_time: rand(15..45), discharge_time: rand(15..45) }
    start_time += 60*60
  end
  File.write('../tmp/data.json', data.to_json)
  pp data
end

main