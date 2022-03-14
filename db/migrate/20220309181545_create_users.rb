class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.date :dob
      t.string :gender, default: "male"
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
