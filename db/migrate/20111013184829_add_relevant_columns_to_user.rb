class AddRelevantColumnsToUser < ActiveRecord::Migration
  def self.up
    change_table "users" do |t|
        t.string   "email"
        t.string   "crypted_password"
        t.string   "password_salt"
        t.string   "persistence_token"
        t.string   "name"
        t.string   "address"
    end
  end

  def self.down
      remove_column :users, :email
      remove_column :users, :crypted_password
      remove_column :users, :password_salt
      remove_column :users, :persistance_token
      remove_column :users, :name
      remove_column :users, :address
  end
end
