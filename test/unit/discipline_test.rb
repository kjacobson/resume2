require 'test_helper'

class DisciplineTest < ActiveSupport::TestCase
    fixtures :jobs, :skills, :job_skills, :disciplines
    # Replace this with your real tests.
    test "should access jobs through skills" do
        @discipline = disciplines(:two)
        @skill_two = skills(:two)
        assert(!@discipline.skills.find(@skill_two.id).nil?)
    end
    test "should be able to count its jobs" do
        @discipline = disciplines(:two)
        assert_equal(@discipline.jobs_count, 2)
    end
end
