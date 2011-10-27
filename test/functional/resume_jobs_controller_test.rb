require 'test_helper'

class ResumeJobsControllerTest < ActionController::TestCase
  setup do
    @resume_job = resume_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resume_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resume_job" do
    assert_difference('ResumeJob.count') do
      post :create, :resume_job => @resume_job.attributes
    end

    assert_redirected_to resume_job_path(assigns(:resume_job))
  end

  test "should show resume_job" do
    get :show, :id => @resume_job.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @resume_job.to_param
    assert_response :success
  end

  test "should update resume_job" do
    put :update, :id => @resume_job.to_param, :resume_job => @resume_job.attributes
    assert_redirected_to resume_job_path(assigns(:resume_job))
  end

  test "should destroy resume_job" do
    assert_difference('ResumeJob.count', -1) do
      delete :destroy, :id => @resume_job.to_param
    end

    assert_redirected_to resume_jobs_path
  end
end
