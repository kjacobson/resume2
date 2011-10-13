class Discipline < ActiveRecord::Base
    validates_presence_of :title
    validates_uniqueness_of :title

    has_many :skills
    has_many :jobs, :through => :skills

    def jobs_using_count
        jobs = self.jobs.reject {|job| job.nil?}
        return jobs.count
    end
end
