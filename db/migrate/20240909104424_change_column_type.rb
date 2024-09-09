class ChangeColumnType < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :address, :text
  end
end
