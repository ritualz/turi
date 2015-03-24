class EquipmentList < ActiveRecord::Base
    belongs_to :trip
    has_many :equipment_items

    validates_presence_of :name
    validates_presence_of :description
end
