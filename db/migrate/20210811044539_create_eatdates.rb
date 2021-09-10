class CreateEatdates < ActiveRecord::Migration[6.1]
  def change
    create_table :eatdates do |t|
      t.date  :date, null: false, index: true
      t.integer :timezone, null: false, index: true
      t.time :eat_time
      t.text :comment
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
