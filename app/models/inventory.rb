class Inventory
  include Mongoid::Document

  embedded_in :activation

  field :accb, type: Array, default: []
  field :mats, type: Array, default: []
  field :pcus, type: Array, default: []
  field :batteries, type: Array, default: []
  field :meters, type: Array, default: []
  field :relays, type: Array, default: []
end