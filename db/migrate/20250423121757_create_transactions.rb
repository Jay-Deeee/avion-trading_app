class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :symbol
      t.decimal :shares, precision: 5, scale: 2
      t.decimal :price, precision: 7, scale: 4
      t.decimal :total, precision: 10, scale: 4
      t.string :action_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
