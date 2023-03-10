require "test_helper"

class CreateBoardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @create_board = create_boards(:one)
  end

  test "should get index" do
    get create_boards_url
    assert_response :success
  end

  test "should get new" do
    get new_create_board_url
    assert_response :success
  end

  test "should create create_board" do
    assert_difference("CreateBoard.count") do
      post create_boards_url, params: { create_board: { board_desc: @create_board.board_desc, board_title: @create_board.board_title } }
    end

    assert_redirected_to create_board_url(CreateBoard.last)
  end

  test "should show create_board" do
    get create_board_url(@create_board)
    assert_response :success
  end

  test "should get edit" do
    get edit_create_board_url(@create_board)
    assert_response :success
  end

  test "should update create_board" do
    patch create_board_url(@create_board), params: { create_board: { board_desc: @create_board.board_desc, board_title: @create_board.board_title } }
    assert_redirected_to create_board_url(@create_board)
  end

  test "should destroy create_board" do
    assert_difference("CreateBoard.count", -1) do
      delete create_board_url(@create_board)
    end

    assert_redirected_to create_boards_url
  end
end
