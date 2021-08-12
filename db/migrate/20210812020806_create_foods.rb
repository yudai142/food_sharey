class CreateFoods < ActiveRecord::Migration[6.1]
  def change
    create_table :foods do |t|
      t.string  :name, null: false
      t.string :image
      t.integer :calorie
      t.integer :protein
      t.integer :fat
      t.integer :carbohydrate
      t.integer :sugar
      t.integer :dietary_fiber
      t.integer :salt
      t.integer :Vitamin_A
      t.integer :Vitamin_D
      t.integer :Vitamin_E
      t.integer :Vitamin_B1
      t.integer :Vitamin_B2
      t.integer :Vitamin_B6
      t.integer :Vitamin_B12
      t.integer :Vitamin_C
      t.integer :potassium
      t.integer :calcium
      t.integer :magnesium
      t.integer :iron
      t.references :eatdate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
