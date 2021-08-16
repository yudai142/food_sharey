class ChangeColumnToMymenusNutrition < ActiveRecord::Migration[6.1]
  def change
    change_column :mymenus, :calorie, :integer, defalut: 0
    change_column :mymenus, :protein, :integer, defalut: 0
    change_column :mymenus, :fat, :integer, defalut: 0
    change_column :mymenus, :carbohydrate, :integer, defalut: 0
    change_column :mymenus, :sugar, :integer, defalut: 0
    change_column :mymenus, :dietary_fiber, :integer, defalut: 0
    change_column :mymenus, :salt, :integer, defalut: 0
    change_column :mymenus, :Vitamin_A, :integer, defalut: 0
    change_column :mymenus, :Vitamin_D, :integer, defalut: 0
    change_column :mymenus, :Vitamin_E, :integer, defalut: 0
    change_column :mymenus, :Vitamin_B1, :integer, defalut: 0
    change_column :mymenus, :Vitamin_B2, :integer, defalut: 0
    change_column :mymenus, :Vitamin_B6, :integer, defalut: 0
    change_column :mymenus, :Vitamin_B12, :integer, defalut: 0
    change_column :mymenus, :Vitamin_C, :integer, defalut: 0
    change_column :mymenus, :potassium, :integer, defalut: 0
    change_column :mymenus, :calcium, :integer, defalut: 0
    change_column :mymenus, :magnesium, :integer, defalut: 0
    change_column :mymenus, :iron, :integer, defalut: 0
  end
end
