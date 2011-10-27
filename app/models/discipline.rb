class Discipline < ActiveRecord::Base
    validates_presence_of :title
    validates_uniqueness_of :title
    belongs_to :user

    has_many :skills

    def jobs
        self.skills.flat_map{ |sk| sk.jobs }.uniq        
    end

    def jobs_count
        jobs = self.jobs.reject {|job| job.nil?}
        return jobs.count
    end
end
