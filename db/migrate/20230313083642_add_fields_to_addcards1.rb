class AddFieldsToAddcards1 < ActiveRecord::Migration[7.0]
  def change
    add_column :addcards, :desc, :text
  end
end
