class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.text :address
      t.string :type
      t.boolean :default, default: false

      t.timestamps
    end
  end
end
