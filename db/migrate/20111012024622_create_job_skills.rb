class CreateJobSkills < ActiveRecord::Migration
  def self.up
    create_table :job_skills do |t|
      t.integer :job_id
      t.integer :skill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :job_skills
  end
end
