class CreateSoftwares < ActiveRecord::Migration
  def self.up
    create_table :softwares do |t|
      t.string :title
      t.string :slug
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :softwares
  end
end
