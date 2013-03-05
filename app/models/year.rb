class Year
    attr_accessor :value

    def initialize(value)
        self.value = value
    end

    def jobs(user=nil, resume=nil)
      return @job if !@job.nil?
      if !user.nil? and !resume.nil?
        @job = resume.jobs.where("start_year <= ? AND end_year >= ?", self.value, self.value)
      elsif !user.nil?
        @job = user.jobs.where("start_year <= ? AND end_year >= ?", self.value, self.value)
      else
        @job = Job.where("start_year <= ? AND end_year >= ?", self.value, self.value)
      end
      return @job
    end
    def skills(user=nil, resume=nil)
        self.jobs(user, resume).flat_map{ |j| j.skills }.uniq
    end
    def softwares(user=nil, resume=nil)
        self.jobs(user, resume).flat_map{ |j| j.softwares }.uniq
    end
    def highlights(user=nil, resume=nil)
        self.jobs(user, resume).flat_map{ |j| j.highlights }.uniq
    end
end
