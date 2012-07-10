class ResumeJob < ActiveRecord::Base
    validates_presence_of :resume_id
    validates_presence_of :job_id

    belongs_to :resume
    belongs_to :job
end
