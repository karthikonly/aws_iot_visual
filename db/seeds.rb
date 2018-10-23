def serial_no
  rand.to_s[2..10]
end

def generate_count(min, max)
  ((max-min)* rand + min).round
end

MIN_MAX = {
  "accb" => [1,1],
  "mats" => [1,1],
  "pcus" => [5,12],
  "batteries" => [1,4],
  "meters" => [2,4],
  "qrelays" => [1,1]
}

def main
  act = Activation.new
  act.name = FFaker::Name.name
  act.stage = 0
  act.location_address = FFaker::AddressUS.street_address
  act.location_city = FFaker::AddressUS.city
  act.location_state = FFaker::AddressUS.state
  act.location_zip = FFaker::AddressUS.zip_code

  act.discovered_count = {}
  act.discovered = {}
  act.provisioned_count = {}
  act.provisioned = {}

  Activation::TYPES.each do |type|
    act.provisioned_count[type] = generate_count(*MIN_MAX[type])
    act.provisioned_count[type].times do
      act.provisioned[type] ||= []
      act.provisioned[type] << serial_no
    end
    act.discovered_count[type] = generate_count(*MIN_MAX[type])
    act.discovered_count[type].times do
      act.discovered[type] ||= []
      act.discovered[type] << serial_no
    end
  end

  pp act
  act.save
end

main