require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  setup do
    @activity = activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity" do
    assert_difference('Activity.count') do
      post :create, activity: { activitytype: @activity.activitytype, actualfinish: @activity.actualfinish, actualstart: @activity.actualstart, bCompleted: @activity.bCompleted, bDel: @activity.bDel, completeby: @activity.completeby, contactid: @activity.contactid, description: @activity.description, name: @activity.name, targetfinish: @activity.targetfinish, targetstart: @activity.targetstart, userid: @activity.userid }
    end

    assert_redirected_to activity_path(assigns(:activity))
  end

  test "should show activity" do
    get :show, id: @activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity
    assert_response :success
  end

  test "should update activity" do
    put :update, id: @activity, activity: { activitytype: @activity.activitytype, actualfinish: @activity.actualfinish, actualstart: @activity.actualstart, bCompleted: @activity.bCompleted, bDel: @activity.bDel, completeby: @activity.completeby, contactid: @activity.contactid, description: @activity.description, name: @activity.name, targetfinish: @activity.targetfinish, targetstart: @activity.targetstart, userid: @activity.userid }
    assert_redirected_to activity_path(assigns(:activity))
  end

  test "should destroy activity" do
    assert_difference('Activity.count', -1) do
      delete :destroy, id: @activity
    end

    assert_redirected_to activities_path
  end
end
