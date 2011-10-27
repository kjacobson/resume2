class ResumeHighlight < ActiveRecord::Base
    validates_presence_of :resume_id
    validates_presence_of :highlight_id

    belongs_to :resume
    belongs_to :highlight
end
