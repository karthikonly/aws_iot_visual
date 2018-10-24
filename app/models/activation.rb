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
	field :discovered, type: Hash, default: {}

	embeds_one :location, class_name: 'Location'

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
    set_val(:provisioned, [])
    set_val(:discovered, [])
  end

  def full_address
    [location.address, location.city, location.zipcode, location.state, location.country].compact.join(', ')
  end
end
