class AddUserContactInformation < ActiveRecord::Migration
  def up
    add_column :users, :phone, :text
  end

  def down
    remove_column :users, :phone
  end
end
