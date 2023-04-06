class AddFieldsToAddcomments < ActiveRecord::Migration[7.0]
  def change
    add_column :addcomments, :user_name, :string
  end
end
