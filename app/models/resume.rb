class Resume < ActiveRecord::Base
    belongs_to :user
    has_many :jobs
    has_many :resume_jobs
    has_many :jobs, :through => :resume_jobs
    has_many :resume_highlights
    has_many :highlights, :through => :resume_highlights
    belongs_to :user

    def skills
      skills = self.jobs.flat_map{ |j| j.skills }.uniq
      if skills.first.nil?
        skills = []
      end
      return skills
    end

    def disciplines
      disciplines = self.skills.flat_map{ |sk| sk.discipline }.uniq
    end

    def softwares
      softwares = self.jobs.flat_map{ |j| j.softwares }.uniq
      if softwares.first.nil?
        softwares = []
      end
      return softwares
    end
end
