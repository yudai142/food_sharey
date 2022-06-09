class ChangeColumnPosition < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :name, :string, null: false, after: :email
    change_column :foods, :mymenu_id, :integer, after: :image
  end
end
