class CreateResumeJobs < ActiveRecord::Migration
  def self.up
    create_table :resume_jobs do |t|
      t.integer :resume_id, :index => true
      t.integer :job_id, :index => true

      t.timestamps
    end
  end

  def self.down
    drop_table :resume_jobs
  end
end
