class MakeLinksTableMoreSensible < ActiveRecord::Migration
  def up
    add_column :links, :hash, :string
    remove_column :links, :user_id
    remove_column :links, :url
  end

  def down
    add_column :links, :url, :text
    add_column :links, :user_id, :integer
    remove_column :links, :hash
  end
end
