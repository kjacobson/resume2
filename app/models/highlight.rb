class Highlight < ActiveRecord::Base
    validates_presence_of :job_id
    validates_presence_of :skill_id
    validates_presence_of :description

    belongs_to :job
    belongs_to :skill
end
