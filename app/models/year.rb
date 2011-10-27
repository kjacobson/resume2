class Year
    attr_accessor :value

    def initialize(value)
        self.value = value
    end

    def jobs
        Job.where("start_year <= ? AND end_year >= ?", self.value, self.value)
    end
    def skills
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
