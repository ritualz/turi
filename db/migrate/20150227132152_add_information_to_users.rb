class AddInformationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :country, :string
    add_column :users, :town, :string
    add_column :users, :age, :integer
    add_column :users, :status, :string
    add_column :users, :gender, :integer
  end
end
