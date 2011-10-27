class AddUserAndResumeIDs < ActiveRecord::Migration
  def self.up
      add_column :job_skills, :user_id, :integer
      add_column :job_softwares, :user_id, :integer
      add_column :skills, :user_id, :integer
      add_column :softwares, :user_id, :integer
      add_column :highlights, :user_id, :integer
      add_column :disciplines, :user_id, :integer
  end

  def self.down
      remove_column :jobs, :user_id
      remove_column :job_skills, :user_id
      remove_column :job_softwares, :user_id
      remove_column :skills, :user_id
      remove_column :softwares, :user_id
      remove_column :highlights, :user_id
      remove_column :disciplines, :user_id
  end
end
