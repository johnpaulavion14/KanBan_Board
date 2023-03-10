class AddFieldsToCards < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :create_board_id, :integer
  end
end
