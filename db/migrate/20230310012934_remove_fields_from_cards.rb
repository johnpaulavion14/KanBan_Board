class RemoveFieldsFromCards < ActiveRecord::Migration[7.0]
  def change
    remove_column :cards, :user_id, :integer
  end
end
