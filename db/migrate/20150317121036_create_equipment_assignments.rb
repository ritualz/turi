class CreateEquipmentAssignments < ActiveRecord::Migration
  def change
    create_table :equipment_assignments do |t|
      t.integer :number
      t.timestamps null: false
    end

        add_reference :equipment_assignments, :equipment_item, index: true
        add_reference :equipment_assignments, :user, index: true
        add_foreign_key :equipment_assignments, :equipment_item
        add_foreign_key :equipment_assignments, :user
  end
end
