class Activation
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Attributes::Dynamic

	TYPES = ["accb", "mats", "pcus", "batteries", "meters", "qrelays"]

	# basic site parameters
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

	# before_save :update_siteid

  def siteid
    Digest::SHA2.hexdigest(self.id)[0..5].upcase.to_i(16)
  end

  def full_address
    [self.location_address, self.location_city, self.location_zip, self.location_state].join(', ')
  end
end
