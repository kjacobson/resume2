class CreateResumeHighlights < ActiveRecord::Migration
  def self.up
    create_table :resume_highlights do |t|
      t.integer :resume_id, :index => true
      t.integer :highlight_id, :index => true

      t.timestamps
    end
  end

  def self.down
    drop_table :resume_highlights
  end
end
