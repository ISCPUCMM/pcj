class CreateUserConnections < ActiveRecord::Migration
  def change
    create_table :user_connections do |t|
      t.integer :user_id
      t.integer :connection_id

      t.timestamps null: false
    end

    add_index :user_connections, :user_id
    add_index :user_connections, :connection_id
    add_index :user_connections, [:user_id, :connection_id], unique: true
  end
end
