class JobSkill < ActiveRecord::Base
    validates_presence_of :job_id
    validates_presence_of :skill_id

    belongs_to :job
    belongs_to :skill

    after_save :rank_skills

    def rank_skills
        Skill.rank_skills
    end
end
