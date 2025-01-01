class AddEmailToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email, :string, null: true # nullable.
  end
end
