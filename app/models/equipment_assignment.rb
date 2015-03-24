class EquipmentAssignment < ActiveRecord::Base
    belongs_to :equipment_item

    validates_presence_of :number, allow_nil: false
    validates_presence_of :user_id, allow_nil: false
    validates_presence_of :equipment_item_id, allow_nil: false
end
