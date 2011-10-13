class Year
    attr_accessor :value

    def jobs
        Job.where("start_year >= :val AND end_year <= :val", {:val => self.id})
    end
    def skill
        self.jobs.flat_map{ |j| j.skills }.uniq
    end
    def softwares
        self.jobs.flat_map{ |j| j.softwares }.uniq
    end
    def highlights
        # need to make sure this is only for the current resume somewhere
        self.jobs.flat_map{ |j| j.highlights }.uniq
    end
end
