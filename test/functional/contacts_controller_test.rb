require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, contact: { altphone: @contact.altphone, bClient: @contact.bClient, bDel: @contact.bDel, bMentor: @contact.bMentor, bSendMail: @contact.bSendMail, contactsource: @contact.contactsource, contacttype: @contact.contacttype, email: @contact.email, firstname: @contact.firstname, lastname: @contact.lastname, name: @contact.name, notes: @contact.notes, organization: @contact.organization, phone: @contact.phone, saluation: @contact.saluation, title: @contact.title }
    end

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should show contact" do
    get :show, id: @contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact
    assert_response :success
  end

  test "should update contact" do
    put :update, id: @contact, contact: { altphone: @contact.altphone, bClient: @contact.bClient, bDel: @contact.bDel, bMentor: @contact.bMentor, bSendMail: @contact.bSendMail, contactsource: @contact.contactsource, contacttype: @contact.contacttype, email: @contact.email, firstname: @contact.firstname, lastname: @contact.lastname, name: @contact.name, notes: @contact.notes, organization: @contact.organization, phone: @contact.phone, saluation: @contact.saluation, title: @contact.title }
    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact
    end

    assert_redirected_to contacts_path
  end
end
