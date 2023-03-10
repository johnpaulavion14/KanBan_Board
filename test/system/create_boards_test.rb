require "application_system_test_case"

class CreateBoardsTest < ApplicationSystemTestCase
  setup do
    @create_board = create_boards(:one)
  end

  test "visiting the index" do
    visit create_boards_url
    assert_selector "h1", text: "Create boards"
  end

  test "should create create board" do
    visit create_boards_url
    click_on "New create board"

    fill_in "Board desc", with: @create_board.board_desc
    fill_in "Board title", with: @create_board.board_title
    click_on "Create Create board"

    assert_text "Create board was successfully created"
    click_on "Back"
  end

  test "should update Create board" do
    visit create_board_url(@create_board)
    click_on "Edit this create board", match: :first

    fill_in "Board desc", with: @create_board.board_desc
    fill_in "Board title", with: @create_board.board_title
    click_on "Update Create board"

    assert_text "Create board was successfully updated"
    click_on "Back"
  end

  test "should destroy Create board" do
    visit create_board_url(@create_board)
    click_on "Destroy this create board", match: :first

    assert_text "Create board was successfully destroyed"
  end
end
