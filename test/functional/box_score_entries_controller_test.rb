require 'test_helper'

class BoxScoreEntriesControllerTest < ActionController::TestCase
  setup do
    @box_score_entry = box_score_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:box_score_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create box_score_entry" do
    assert_difference('BoxScoreEntry.count') do
      post :create, :box_score_entry => @box_score_entry.attributes
    end

    assert_redirected_to box_score_entry_path(assigns(:box_score_entry))
  end

  test "should show box_score_entry" do
    get :show, :id => @box_score_entry.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @box_score_entry.to_param
    assert_response :success
  end

  test "should update box_score_entry" do
    put :update, :id => @box_score_entry.to_param, :box_score_entry => @box_score_entry.attributes
    assert_redirected_to box_score_entry_path(assigns(:box_score_entry))
  end

  test "should destroy box_score_entry" do
    assert_difference('BoxScoreEntry.count', -1) do
      delete :destroy, :id => @box_score_entry.to_param
    end

    assert_redirected_to box_score_entries_path
  end
end
