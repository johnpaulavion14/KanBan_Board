json.extract! create_board, :id, :board_title, :board_desc, :created_at, :updated_at
json.url create_board_url(create_board, format: :json)
