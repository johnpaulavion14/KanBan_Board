class CreateAddcards < ActiveRecord::Migration[7.0]
  def change
    create_table :addcards do |t|
      t.string :card_name

      t.timestamps
    end
  end
end
