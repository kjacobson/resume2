class Discipline < ActiveRecord::Base
    validates_presence_of :title
    validates_uniqueness_of :title
    has_many :user_skills
    belongs_to :user

    def skills
      user_skills = UserSkill.where(:user_id => self.user.id, :discipline_id => self.id)
      skills = []
      if user_skills.count > 0
        user_skills.each do |us|
          skills.push(us.skill)
        end
      end
      return skills
    end


    def jobs
        self.skills.flat_map{ |sk| sk.jobs }.uniq        
    end

    def job_count
        jobs = self.jobs.reject {|job| job.nil?}
        return jobs.count
    end

    def skill_count
      self.skills.count
    end
end
