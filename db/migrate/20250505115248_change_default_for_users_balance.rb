class ChangeDefaultForUsersBalance < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :balance, from: nil, to: 0.0
    change_column_null :users, :balance, false
  end
end
