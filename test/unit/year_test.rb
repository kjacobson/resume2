require 'test_helper'

class YearTest < ActiveSupport::TestCase
    fixtures :jobs, :job_skills, :skills, :job_softwares, :softwares
    def setup
        @year = Year.new(2009)
    end

    test "should find jobs performed in it" do
        assert_equal(@year.jobs.count, 2)
    end

    test "should find skills used in it through jobs" do
        assert_equal(@year.skills.count, 2)
    end

    test "should find softwares used in it through jobs" do
        assert_equal(@year.softwares.count, 2)
    end

    test "should find skills highlights happening in it through jobs" do
        assert_equal(@year.highlights.count, 2)
    end
end
