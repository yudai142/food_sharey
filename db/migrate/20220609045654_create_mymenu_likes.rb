class CreateMymenuLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :mymenu_likes do |t|
      t.references :mymenu, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
