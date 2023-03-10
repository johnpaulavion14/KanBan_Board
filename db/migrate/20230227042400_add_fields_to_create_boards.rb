class AddFieldsToCreateBoards < ActiveRecord::Migration[7.0]
  def change
    add_column :create_boards, :user_id, :integer
    add_index :create_boards, :user_id
  end
end
