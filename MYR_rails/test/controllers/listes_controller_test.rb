require 'test_helper'

class ListesControllerTest < ActionController::TestCase
  setup do
    @liste = listes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:listes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create liste" do
    assert_difference('Liste.count') do
      post :create, liste: {  }
    end

    assert_redirected_to liste_path(assigns(:liste))
  end

  test "should show liste" do
    get :show, id: @liste
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @liste
    assert_response :success
  end

  test "should update liste" do
    patch :update, id: @liste, liste: {  }
    assert_redirected_to liste_path(assigns(:liste))
  end

  test "should destroy liste" do
    assert_difference('Liste.count', -1) do
      delete :destroy, id: @liste
    end

    assert_redirected_to listes_path
  end
end
