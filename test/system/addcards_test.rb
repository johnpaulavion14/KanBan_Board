require "application_system_test_case"

class AddcardsTest < ApplicationSystemTestCase
  setup do
    @addcard = addcards(:one)
  end

  test "visiting the index" do
    visit addcards_url
    assert_selector "h1", text: "Addcards"
  end

  test "should create addcard" do
    visit addcards_url
    click_on "New addcard"

    fill_in "Card name", with: @addcard.card_name
    click_on "Create Addcard"

    assert_text "Addcard was successfully created"
    click_on "Back"
  end

  test "should update Addcard" do
    visit addcard_url(@addcard)
    click_on "Edit this addcard", match: :first

    fill_in "Card name", with: @addcard.card_name
    click_on "Update Addcard"

    assert_text "Addcard was successfully updated"
    click_on "Back"
  end

  test "should destroy Addcard" do
    visit addcard_url(@addcard)
    click_on "Destroy this addcard", match: :first

    assert_text "Addcard was successfully destroyed"
  end
end
