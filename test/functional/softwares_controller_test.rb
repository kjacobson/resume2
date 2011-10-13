require 'test_helper'

class SoftwaresControllerTest < ActionController::TestCase
  setup do
    @software = softwares(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:softwares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create software" do
    assert_difference('Software.count') do
      post :create, :software => @software.attributes
    end

    assert_redirected_to software_path(assigns(:software))
  end

  test "should show software" do
    get :show, :id => @software.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @software.to_param
    assert_response :success
  end

  test "should update software" do
    put :update, :id => @software.to_param, :software => @software.attributes
    assert_redirected_to software_path(assigns(:software))
  end

  test "should destroy software" do
    assert_difference('Software.count', -1) do
      delete :destroy, :id => @software.to_param
    end

    assert_redirected_to softwares_path
  end
end
