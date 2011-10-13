class Skill < ActiveRecord::Base
    validates_uniqueness_of :title

    has_many :job_skills, :dependent => :destroy
    has_many :jobs, :through => :job_skills, :uniq => true
    has_many :highlights, :dependent => :destroy
    belongs_to :discipline
    belongs_to :user

    def shortest_name
        if !abbreviation.nil? and abbreviation != ""
            return abbreviation
        else
            return title
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
end
