class Activation
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Attributes::Dynamic

	TYPES = ["accb", "mats", "pcus", "batteries", "meters", "qrelays"]

	# basic site parameters
  field :siteid, type: String

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

	before_save :update_siteid

  def set_val(attribute, value)
    self[attribute] ||= {}
    TYPES.each do |type|
      self[attribute][type] ||= value
    end
  end

  def update_siteid
		self.id ||= BSON::ObjectId.from_time(Time.now.utc)
    self.siteid ||= Digest::SHA2.hexdigest(self.id)[0..5].upcase.to_i(16)
    set_val(:provisioned_count, 0)
    set_val(:discovered_count, 0)
    set_val(:provisioned, [])
    set_val(:discovered, [])
  end

  def full_address
    [self.location_address, self.location_city, self.location_zip, self.location_state].join(', ')
  end
end
