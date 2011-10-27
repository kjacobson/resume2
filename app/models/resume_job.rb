class ResumeJob < ActiveRecord::Base
    validates_presence_of :resume
    validates_presence_of :job

    belongs_to :resume
    belongs_to :job
end
