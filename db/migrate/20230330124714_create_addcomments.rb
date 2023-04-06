class CreateAddcomments < ActiveRecord::Migration[7.0]
  def change
    create_table :addcomments do |t|
      t.text :comment
      t.integer :addcard_id

      t.timestamps
    end
  end
end
