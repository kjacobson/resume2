class Highlight < ActiveRecord::Base
    validates_presence_of :job_id
    validates_presence_of :skill_id
    validates_presence_of :description
    has_many :resume_highlights, :dependent => :destroy
    has_many :resumes, :through => :resume_highlights, :uniq => true

    belongs_to :job
    belongs_to :skill
    belongs_to :user
end
