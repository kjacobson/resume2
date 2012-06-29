class Job < ActiveRecord::Base
    validates_presence_of :title
    validates_presence_of :employer
    validates_presence_of :short_desc
    validates_presence_of :status
    
    has_many :job_skills, :dependent => :destroy
    has_many :skills, :through => :job_skills
    has_many :job_softwares, :dependent => :destroy
    has_many :softwares, :through => :job_softwares
    has_many :highlights, :dependent => :destroy
    has_many :resume_jobs, :dependent => :destroy
    has_many :resumes, :through => :resume_jobs, :uniq => true
    belongs_to :user

    def disciplines
        disciplines = self.skills.flat_map{ |sk| sk.discipline }.uniq
        if disciplines.first.nil?
          disciplines = []
        end
        return disciplines
    end

    def years
      years = []
      self.start_year.upto(self.end_year) { |y| years.push(y) }
      return years
    end

    def self.month_converter month
        months = ["Present","January","February","March","April","May","June","July","August","September","October","November", "December"]
        return months[month]
    end

    def self.short_month month
        m = month_converter(month)
        return month == 0 ? m[0..3] : m[0..2]
    end

    def short_start_month
        Job.short_month(self.start_month)
    end
    def short_end_month
        Job.short_month(self.end_month)
    end
    def long_start_month
        Job.month_converter(self.start_month)
    end
    def long_end_month
        Job.month_converter(self.end_month)
    end
end
