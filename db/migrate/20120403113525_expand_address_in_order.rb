class ExpandAddressInOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :address
    
    add_column :orders, :address_index, :string
    add_column :orders, :address_city, :string
    add_column :orders, :address_region, :string
    add_column :orders, :address_street, :string
    add_column :orders, :address_house, :string
    add_column :orders, :address_part, :string
    add_column :orders, :address_build, :string
    add_column :orders, :address_flat, :string
  end
end
