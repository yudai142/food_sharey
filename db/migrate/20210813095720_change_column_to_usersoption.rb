class ChangeColumnToUsersoption < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :food_ideas_hide, :boolean, null: true, default: false
    change_column :users, :user_ranking_hide, :boolean, null: true, default: false
    change_column :users, :release, :boolean, null: true, default: true
  end
end
