class AddFieldsToAddcomments < ActiveRecord::Migration[7.0]
  def change
    add_column :addcomments, :first_name, :string
    add_column :addcomments, :last_name, :string
  end
end
