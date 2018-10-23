def main
  act = Activation.new
  act.name = FFaker::Name.name
  act.stage = 0
  act.location_address = FFaker::AddressUS.street_address
  act.location_city = FFaker::AddressUS.city
  act.location_state = FFaker::AddressUS.state
  act.location_zip = FFaker::AddressUS.zip_code
  act.save
end

main