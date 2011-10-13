class CreateHighlights < ActiveRecord::Migration
  def self.up
    create_table :highlights do |t|
      t.integer :job_id
      t.integer :skill_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :highlights
  end
end
