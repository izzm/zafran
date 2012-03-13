class CreateGoodParameters < ActiveRecord::Migration
  def change
    create_table :good_parameters do |t|
      t.references :good
      t.string :name
      t.string :value
      t.string :unit

      t.timestamps
    end
    add_index :good_parameters, :good_id
  end
end
