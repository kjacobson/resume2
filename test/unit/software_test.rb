require 'test_helper'

class SoftwareTest < ActiveSupport::TestCase
  fixtures :softwares, :job_softwares

  test "should rank softwares by number of jobs using them" do
        assert_equal(Software.find(1).rank, 1)
        assert_equal(Software.find(2).rank, 1)
        assert_equal(Software.find(2).job_softwares.count, 1)
        assert_equal(Software.find(1).job_softwares.count, 1)
        js = JobSoftware.new({:job_id => 3, :software_id => 2})
        assert(js.save)
        assert_equal(Software.find(2).rank, 2)
        assert_equal(Software.find(1).rank, 1)
  end
end
