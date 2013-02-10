class Resume < ActiveRecord::Base
    has_many :resume_jobs
    has_many :jobs, :through => :resume_jobs
    has_many :resume_highlights
    has_many :highlights, :through => :resume_highlights
    has_many :links
    belongs_to :user

    def skills
      skills = self.jobs.flat_map { |j| j.skills }.uniq
      if skills.first.nil?
        skills = []
      end
      return skills
    end

    def disciplines
      user = User.find(self.user_id)
      if user
        disciplines = self.skills.flat_map { |sk| sk.discipline(user) }.uniq.compact
      else
        disciplines = []
      end
      return disciplines
    end

    def softwares
      softwares = self.jobs.flat_map { |j| j.softwares }.uniq
      if softwares.first.nil?
        softwares = []
      end
      return softwares
    end

    def job_count
      self.jobs.count
    end

    def link_count
      self.links.count
    end

    def uncategorized_skills
      skill_ids = self.skills.collect { |sk| sk.id }
      user_skills = self.user.user_skills.select {|us| skill_ids.include?(us.skill_id) and us.discipline_id.nil? }
      return user_skills.collect { |us| us.skill }
    end

    def years
      years = self.jobs.flat_map { |j| j.years }.uniq
    end
end
