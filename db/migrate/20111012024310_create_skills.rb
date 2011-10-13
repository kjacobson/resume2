class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.string :title
      t.string :abbreviation
      t.string :slug
      t.integer :discipline_id
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :skills
  end
end
