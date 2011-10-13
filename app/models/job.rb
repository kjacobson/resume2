class Job < ActiveRecord::Base
    validates_presence_of :title
    validates_presence_of :employer
    validates_presence_of :short_desc
    validates_presence_of :status
    
    has_many :job_skills, :dependent => :destroy
    has_many :skills, :through => :job_skills
    has_many :job_softwares, :dependent => :destroy
    has_many :softwares, :through => :job_softwares
    has_many :job_years, :dependent => :destroy
    has_many :highlights, :dependent => :destroy
    belongs_to :user

    def disciplines
        self.skills.flat_map{ |sk| sk.discipline }.uniq
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
        self.short_month(self.start_month)
    end
    def short_end_month
        self.short_month(self.end_month)
    end
    def long_start_month
        self.month_converter(self.end_month)
    end
    def long_end_month
        self.month_converter(self.end_month)
    end
end
