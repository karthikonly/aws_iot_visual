class InventoryCount
  include Mongoid::Document

  embedded_in :activation

  field :accb, type: Integer, default: 0
  field :mats, type: Integer, default: 0
  field :pcus, type: Integer, default: 0
  field :batteries, type: Integer, default: 0
  field :meters, type: Integer, default: 0
  field :relays, type: Integer, default: 0
end