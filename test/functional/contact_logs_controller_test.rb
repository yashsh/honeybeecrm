require 'test_helper'

class ContactLogsControllerTest < ActionController::TestCase
  setup do
    @contact_log = contact_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contact_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact_log" do
    assert_difference('ContactLog.count') do
      post :create, contact_log: { bSuccess: @contact_log.bSuccess, contactid: @contact_log.contactid, contactname: @contact_log.contactname, email: @contact_log.email, logdate: @contact_log.logdate, logdetail: @contact_log.logdetail, logtype: @contact_log.logtype }
    end

    assert_redirected_to contact_log_path(assigns(:contact_log))
  end

  test "should show contact_log" do
    get :show, id: @contact_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact_log
    assert_response :success
  end

  test "should update contact_log" do
    put :update, id: @contact_log, contact_log: { bSuccess: @contact_log.bSuccess, contactid: @contact_log.contactid, contactname: @contact_log.contactname, email: @contact_log.email, logdate: @contact_log.logdate, logdetail: @contact_log.logdetail, logtype: @contact_log.logtype }
    assert_redirected_to contact_log_path(assigns(:contact_log))
  end

  test "should destroy contact_log" do
    assert_difference('ContactLog.count', -1) do
      delete :destroy, id: @contact_log
    end

    assert_redirected_to contact_logs_path
  end
end
