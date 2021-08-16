class CreateFoods < ActiveRecord::Migration[6.1]
  def change
    create_table :foods do |t|
      t.string  :name, null: false
      t.string :image
      t.integer :calorie, defalut: 0
      t.integer :protein, defalut: 0
      t.integer :fat, defalut: 0
      t.integer :carbohydrate, defalut: 0
      t.integer :sugar, defalut: 0
      t.integer :dietary_fiber, defalut: 0
      t.integer :salt, defalut: 0
      t.integer :Vitamin_A, defalut: 0
      t.integer :Vitamin_D, defalut: 0
      t.integer :Vitamin_E, defalut: 0
      t.integer :Vitamin_B1, defalut: 0
      t.integer :Vitamin_B2, defalut: 0
      t.integer :Vitamin_B6, defalut: 0
      t.integer :Vitamin_B12, defalut: 0
      t.integer :Vitamin_C, defalut: 0
      t.integer :potassium, defalut: 0
      t.integer :calcium, defalut: 0
      t.integer :magnesium, defalut: 0
      t.integer :iron, defalut: 0
      t.references :eatdate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
