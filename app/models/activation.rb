require 'autoinc'

class Activation
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Autoinc
	include Mongoid::Attributes::Dynamic

	TYPES = ["accb", "mats", "pcus", "batteries", "meters", "qrelays"]

	# basic site parameters
	field :siteid, type: Integer
	field :name, type: String
	field :location_zip, type: String
	field :location_city, type: String
	field :location_state, type: String
	field :location_address, type: String
	
	field :stage, type: Integer

	# provisioned information
	field :provisioned_count, type: Hash
	field :provisioned, type: Hash

	# discovered information
	field :discovered_count, type: Hash
	field :discovered, type: Hash

	increments :siteid
end
