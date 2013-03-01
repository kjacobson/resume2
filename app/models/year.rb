class Year
    attr_accessor :value

    def initialize(value)
        self.value = value
    end

    def jobs(resume=nil)
      return @job if !@job.nil?
      if resume.nil?
        @job = Job.where("start_year <= ? AND end_year >= ?", self.value, self.value)
      else
        @job = resume.jobs.where("start_year <= ? AND end_year >= ?", self.value, self.value)
      end
      return @job
    end
    def skills(resume=nil)
        self.jobs(resume).flat_map{ |j| j.skills }.uniq
    end
    def softwares(resume=nil)
        self.jobs(resume).flat_map{ |j| j.softwares }.uniq
    end
    def highlights(resume=nil)
        self.jobs(resume).flat_map{ |j| j.highlights }.uniq
    end
end
