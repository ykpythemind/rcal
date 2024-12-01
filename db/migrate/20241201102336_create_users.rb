class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :uid, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
