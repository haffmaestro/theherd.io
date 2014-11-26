class ReindexUsersByEmailAndSubdomain < ActiveRecord::Migration
  def change
    add_column :users, :subdomain, :string
    remove_index :users, :email
    add_index :users, [:email, :subdomain], :unique => true
  end
end
