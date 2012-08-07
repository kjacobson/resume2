class Discipline < ActiveRecord::Base
    validates_presence_of :title
    validates_uniqueness_of :title
    belongs_to :user

    def skills(user)
        user_skills = discipline.user_skills.reject { |us| us.user_id != user.id }
        skills = user_skills.flat_map { |us| us.skill }.uniq
    end


    def jobs
        self.skills.flat_map{ |sk| sk.jobs }.uniq        
    end

    def jobs_count
        jobs = self.jobs.reject {|job| job.nil?}
        return jobs.count
    end
end
