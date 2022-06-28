class CreateEatdateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :eatdate_likes do |t|
      t.references :eatdate, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
