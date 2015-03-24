class CreateEquipmentItems < ActiveRecord::Migration
  def change
    create_table :equipment_items do |t|
      t.string      :name
      t.float      :price, default: 0.0
      t.integer     :number, default: 1

      t.timestamps null: false
    end
        add_reference :equipment_items, :equipment_list, index: true
        add_reference :equipment_items, :user, index: true
        add_foreign_key :equipment_items, :equipment_list
        add_foreign_key :equipment_items, :user
  end
end
