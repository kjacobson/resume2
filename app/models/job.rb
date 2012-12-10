class Job < ActiveRecord::Base
    JOB_STATUSES = ["full-time", "part-time", "contract", "side project", "other"]

    validates_inclusion_of :status, :in => JOB_STATUSES

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
        u = self.user
        disciplines = self.skills.flat_map{ |sk| sk.discipline(u) }.uniq.compact
        if disciplines.first.nil? or !disciplines.first
          disciplines = []
        end
        return disciplines
    end

    def self.status_options
      JOB_STATUSES
    end

    def years
      years = []
      self.start_year.upto(self.end_year) { |y| years.push(y) }
      return years.map { |yr| Year.new(yr) }
    end

    def self.month_converter month
        if month.nil?
          month = 0
        end
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

    def uncategorized_skills
      skill_ids = self.skills.collect { |sk| sk.id }
      user_skills = self.user.user_skills.select {|us| skill_ids.include?(us.skill_id) and us.discipline_id.nil? }
      return user_skills.collect { |us| us.skill }
    end
end
