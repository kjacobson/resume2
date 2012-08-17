class Discipline < ActiveRecord::Base
    validates_presence_of :title
    validates_uniqueness_of :title
    belongs_to :user
    has_many :user_skills

    def skills(user)
      user_skills = UserSkill.where(:user_id => user.id, :discipline_id => self.id)
      skills = []
      if user_skills.count > 0
        user_skills.each do |us|
          skills.push(user_skill.skill)
        end
      end
    end


    def jobs
        self.skills.flat_map{ |sk| sk.jobs }.uniq        
    end

    def jobs_count
        jobs = self.jobs.reject {|job| job.nil?}
        return jobs.count
    end
end
