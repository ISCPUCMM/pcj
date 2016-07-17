class AddConnectionTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :connection_token, :string
  end
end
