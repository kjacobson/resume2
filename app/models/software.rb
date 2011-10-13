class Software < ActiveRecord::Base
    validates_presence_of :title
    validates_uniqueness_of :title

    has_many :job_softwares, :dependent => :destroy
    has_many :jobs, :through => :job_softwares
    belongs_to :user

    def self.rank_softwares
        softwares = self.all
        softwares = softwares.sort! { |a,b| b.job_softwares.count <=> a.job_softwares.count }
        rank = softwares.size
        softwares.each do |software|
            software.update_rank(rank)
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
