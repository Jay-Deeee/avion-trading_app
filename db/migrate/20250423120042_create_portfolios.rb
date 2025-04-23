class CreatePortfolios < ActiveRecord::Migration[7.2]
  def change
    create_table :portfolios do |t|
      t.string :stocks
      t.decimal :current_shares, precision: 5, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
