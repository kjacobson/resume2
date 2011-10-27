class Resume < ActiveRecord::Base
    belongs_to :user
    has_many :jobs
    has_many :softwares
    has_many :resume_jobs
    has_many :jobs, :through => :resume_jobs
    has_many :resume_highlights
    has_many :highlights, :through => :resume_highlights
    belongs_to :user
end
