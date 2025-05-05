class AddConstraintsToBalanceAndShares < ActiveRecord::Migration[7.2]
  def change
    execute <<-SQL
      ALTER TABLE users
      ADD CONSTRAINT balance_non_negative
      CHECK (balance >= 0);
    SQL

    execute <<-SQL
      ALTER TABLE portfolios
      ADD CONSTRAINT current_shares_non_negative
      CHECK (current_shares >= 0);
    SQL
  end
end
