class ChangeColumnToUsersoption < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :food_ideas_hide, :boolean, null: true
    change_column :users, :user_ranking_hide, :boolean, null: true
    change_column :users, :release, :boolean, null: true
  end
end
