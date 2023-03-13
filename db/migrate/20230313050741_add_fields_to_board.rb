class AddFieldsToBoard < ActiveRecord::Migration[7.0]
  def change
    add_column :create_boards, :group, :boolean, :default => false
  end
end
