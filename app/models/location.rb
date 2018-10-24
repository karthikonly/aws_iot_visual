class Location
  include Mongoid::Document
  embedded_in :activation

  field :address, type: String
  field :city, type: String
  field :country, type: String
  field :state, type: String
  field :zipcode, type: String
end