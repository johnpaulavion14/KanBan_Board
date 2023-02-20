class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :card_title

      t.timestamps
    end
  end
end
