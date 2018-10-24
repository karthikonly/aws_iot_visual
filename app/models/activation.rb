class Activation
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Attributes::Dynamic

	TYPES = ["accb", "mats", "pcus", "batteries", "meters", "qrelays"]

	# basic site parameters
  field :siteid, type: String
	field :name, type: String
	
	field :stage, type: Integer

	# provisioned information
	field :provisioned_count, type: Hash, default: {}
	field :provisioned, type: Hash, default: {}

	# discovered information
	field :discovered_count, type: Hash, default: {}
	field :discovered, type: Hash, default: {}

	embeds_one :location, class_name: 'Location'

	before_save :update_siteid

  def update_siteid
		self.id ||= BSON::ObjectId.from_time(Time.now.utc)
    self.siteid ||= Digest::SHA2.hexdigest(self.id)[0..5].upcase.to_i(16)
  end

  def full_address
    [self.location_address, self.location_city, self.location_zip, self.location_state].join(', ')
  end
end
