require 'test_helper'

class MembersControllerTest < ActionController::TestCase

  setup do
    @member = members(:one)
  end
=begin
  test "should get index" do
    get :index
    assert_response :success
    assert_select "title", "Members | Index"
#    assert_not_nil assigns(:members)
  end
=end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Members | New"
  end

=begin
  test "should create member" do
    assert_difference('Member.count') do
      post :create, member: { email: @member.email, logo: @member.logo, name: @member.name, password: @member.password, role: @member.role, team_id: @member.team_id }
    end

    assert_redirected_to member_path(assigns(:member))
  end

  test "should show member" do
    get :show, id: @member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @member
    assert_response :success
  end

  test "should update member" do
    patch :update, id: @member, member: { email: @member.email, logo: @member.logo, name: @member.name, password: @member.password, role: @member.role, team_id: @member.team_id }
    assert_redirected_to member_path(assigns(:member))
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete :destroy, id: @member
    end

    assert_redirected_to members_path
  end
=end
end
