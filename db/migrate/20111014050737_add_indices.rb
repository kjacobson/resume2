class AddIndices < ActiveRecord::Migration
  def self.up
      add_index :highlights, :user_id
      add_index :highlights, :job_id
      add_index :highlights, :skill_id
      add_index :job_skills, :user_id
      add_index :job_skills, :job_id
      add_index :job_skills, :skill_id
      add_index :job_softwares, :user_id
      add_index :job_softwares, :job_id
      add_index :job_softwares, :software_id
      add_index :jobs, :user_id
      add_index :jobs, :start_month
      add_index :jobs, :end_month
      add_index :jobs, :start_year
      add_index :jobs, :end_year
      add_index :skills, :user_id
      add_index :skills, :discipline_id
      add_index :disciplines, :user_id
      add_index :resumes, :user_id
  end

  def self.down
      remove_index :highlights, :user_id
      remove_index :highlights, :job_id
      remove_index :highlights, :skill_id
      remove_index :job_skills, :user_id
      remove_index :job_skills, :job_id
      remove_index :job_skills, :skill_id
      remove_index :job_softwares, :user_id
      remove_index :job_softwares, :job_id
      remove_index :job_softwares, :software_id
      remove_index :jobs, :user_id
      remove_index :jobs, :start_month
      remove_index :jobs, :end_month
      remove_index :jobs, :start_year
      remove_index :jobs, :end_year
      remove_index :skills, :user_id
      remove_index :skills, :discipline_id
      remove_index :disciplines, :user_id
      remove_index :resumes, :user_id
  end
end
