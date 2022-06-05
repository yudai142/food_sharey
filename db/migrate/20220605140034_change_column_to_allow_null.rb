class ChangeColumnToAllowNull < ActiveRecord::Migration[6.1]
  def up
    change_column :mymenus, :category_id,:integer, null: true
  end

  def down
    change_column :mymenus, :category_id,:integer, null: false
  end
end
