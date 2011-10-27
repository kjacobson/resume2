class JobSoftware < ActiveRecord::Base
    validates_presence_of :job_id
    validates_presence_of :software_id

    after_save :rank_softwares

    belongs_to :job
    belongs_to :software
    belongs_to :user

    def rank_softwares
        Software.rank_softwares
    end
end
