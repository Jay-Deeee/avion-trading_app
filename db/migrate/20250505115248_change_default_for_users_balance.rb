class ChangeDefaultForUsersBalance < ActiveRecord::Migration[7.2]
  def up
    User.where(balance: nil).update_all(balance: 0.0)

    change_column_default :users, :balance, from: nil, to: 0.0
    change_column_null :users, :balance, false
  end

  def down
    change_column_null :users, :balance, true
    change_column_default :users, :balance, from: 0.0, to: nil
  end
end
