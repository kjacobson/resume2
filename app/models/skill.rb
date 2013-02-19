class Skill < ActiveRecord::Base
    validates_uniqueness_of :title

    has_many :job_skills, :dependent => :destroy
    has_many :jobs, :through => :job_skills, :uniq => true
    has_many :user_skills, :dependent => :destroy
    has_many :users, :through => :user_skills
    has_many :highlights, :dependent => :destroy

    def years
      self.jobs.flat_map{ |j| j.years }.uniq
    end

    def shortest_name
        if !abbreviation.nil? and abbreviation != ""
            return abbreviation
        else
            return title
        end
    end

    def discipline(user)
      user_skills = UserSkill.where(:user_id => user.id, :skill_id => self.id)
      if user_skills.count == 1 and !user_skills.first.discipline_id.nil?
        discipline = user_skills.first.discipline
        return discipline
      else
        return nil
      end
    end

    def self.rank_skills
        skills = self.all
        skills = skills.sort! { |a,b| b.job_skills.count <=> a.job_skills.count }
        rank = skills.size
        skills.each do |skill|
            skill.update_rank(rank)
            rank -= 1
        end
    end

    def update_rank(rank)
        self.rank = rank
        if self.save
             return true
        end
    end

    def job_count
        self.jobs.count
    end
end
