class AddNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :food_ideas_hide, :boolean, null: false, defalut: 0
    add_column :users, :user_ranking_hide, :boolean, null: false, defalut: 0
    add_column :users, :release, :boolean, null: false, defalut: 0
  end
end
