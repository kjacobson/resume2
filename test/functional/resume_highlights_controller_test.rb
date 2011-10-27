require 'test_helper'

class ResumeHighlightsControllerTest < ActionController::TestCase
  setup do
    @resume_highlight = resume_highlights(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resume_highlights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resume_highlight" do
    assert_difference('ResumeHighlight.count') do
      post :create, :resume_highlight => @resume_highlight.attributes
    end

    assert_redirected_to resume_highlight_path(assigns(:resume_highlight))
  end

  test "should show resume_highlight" do
    get :show, :id => @resume_highlight.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @resume_highlight.to_param
    assert_response :success
  end

  test "should update resume_highlight" do
    put :update, :id => @resume_highlight.to_param, :resume_highlight => @resume_highlight.attributes
    assert_redirected_to resume_highlight_path(assigns(:resume_highlight))
  end

  test "should destroy resume_highlight" do
    assert_difference('ResumeHighlight.count', -1) do
      delete :destroy, :id => @resume_highlight.to_param
    end

    assert_redirected_to resume_highlights_path
  end
end
