require 'test_helper'

class JobTest < ActiveSupport::TestCase
    fixtures :jobs, :skills, :job_skills, :disciplines

    def valid_job_attributes
        jobs(:one).attributes
    end
    def should_be_valid(record)
        assert(record.valid?)
    end
    def setup
       @job = Job.new
    end

    test "should correctly convert numerical month to abbreviated month name" do
        @job.attributes = valid_job_attributes
        should_be_valid(@job)
        assert_equal(@job.start_month, 1)
        assert_equal(@job.short_start_month, "Jan")
        assert_equal(@job.end_month, 0)
        assert_equal(@job.short_end_month, "Pres")
    end

    test "should correctly convert numerical month to full month name" do
        @job.attributes = valid_job_attributes
        should_be_valid(@job)
        assert_equal(@job.start_month, 1)
        assert_equal(@job.long_start_month, "January")
        assert_equal(@job.end_month, 0)
        assert_equal(@job.long_end_month, "Present")
    end

    test "should inherit disciplines from skills" do
        @job = jobs(:one)
        @skill = skills(:one)
        assert_equal(@job.skills.first.id, @skill.id)
        assert_equal(@job.skills.first.discipline.title, @job.disciplines.first.title)
    end

    test "job should report uncategorized skills" do
        @job_one = jobs(:one)
        assert_equal(@job.uncategorized_skills, [])
        @job_two = jobs(:two)
        assert_equal(@job.uncategorized_skills, [skills(:two)])
    end
end
