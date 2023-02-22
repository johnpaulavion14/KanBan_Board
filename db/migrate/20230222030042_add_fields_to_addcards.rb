class AddFieldsToAddcards < ActiveRecord::Migration[7.0]
  def change
    add_column :addcards, :card_id, :integer
    add_index :addcards, :card_id
  end
end
