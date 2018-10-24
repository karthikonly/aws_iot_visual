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
	embeds_one :provisioned_count, as: :inventory_count, class_name: 'InventoryCount'
	embeds_one :provisioned, as: :inventory, class_name: 'Inventory'

	# discovered information
	embeds_one :discovered_count, as: :inventory_count, class_name: 'InventoryCount'
	embeds_one :discovered, as: :inventory, class_name: 'Inventory'

	embeds_one :location, class_name: 'Location'

	before_save :update_siteid

  def update_siteid
		self.id ||= BSON::ObjectId.from_time(Time.now.utc)
    self.siteid ||= Digest::SHA2.hexdigest(self.id)[0..5].upcase.to_i(16)
  end

  def full_address
    [self.location.address, self.location.city, self.location.zipcode, self.location.state].join(', ')
  end
end
