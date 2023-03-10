class CreateCreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :create_boards do |t|
      t.string :board_title
      t.string :board_desc

      t.timestamps
    end
  end
end
