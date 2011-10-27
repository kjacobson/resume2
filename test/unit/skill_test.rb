require 'test_helper'

class SkillTest < ActiveSupport::TestCase
    fixtures :skills, :jobs, :job_skills
  
    test "should find the shortest name for itself" do
        @skill = skills(:one)
        assert_equal(@skill.shortest_name, "Wireframing")
        @skill.abbreviation = "WF"
        assert_equal(@skill.shortest_name, "WF")
    end

    test "should rank skills by number of jobs using them" do
        assert_equal(Skill.find(1).rank, 1)
        assert_equal(Skill.find(2).rank, 1)
        assert_equal(Skill.find(3).rank, 1)
        assert_equal(Skill.find(3).job_skills.count, 2)
        assert_equal(Skill.find(2).job_skills.count, 1)
        assert_equal(Skill.find(1).job_skills.count, 1)
        Skill.rank_skills
        assert_equal(Skill.find(3).rank, 3)
        assert_operator(Skill.find(2).rank, :>=, 1)
        assert_operator(Skill.find(2).rank, :<=, 2)
        assert_operator(Skill.find(1).rank, :>=, 1)
        assert_operator(Skill.find(1).rank, :<=, 2)
    end
end
