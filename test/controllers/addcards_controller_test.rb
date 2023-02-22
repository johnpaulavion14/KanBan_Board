require "test_helper"

class AddcardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @addcard = addcards(:one)
  end

  test "should get index" do
    get addcards_url
    assert_response :success
  end

  test "should get new" do
    get new_addcard_url
    assert_response :success
  end

  test "should create addcard" do
    assert_difference("Addcard.count") do
      post addcards_url, params: { addcard: { card_name: @addcard.card_name } }
    end

    assert_redirected_to addcard_url(Addcard.last)
  end

  test "should show addcard" do
    get addcard_url(@addcard)
    assert_response :success
  end

  test "should get edit" do
    get edit_addcard_url(@addcard)
    assert_response :success
  end

  test "should update addcard" do
    patch addcard_url(@addcard), params: { addcard: { card_name: @addcard.card_name } }
    assert_redirected_to addcard_url(@addcard)
  end

  test "should destroy addcard" do
    assert_difference("Addcard.count", -1) do
      delete addcard_url(@addcard)
    end

    assert_redirected_to addcards_url
  end
end
