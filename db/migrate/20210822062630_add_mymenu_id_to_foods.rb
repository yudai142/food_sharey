class AddMymenuIdToFoods < ActiveRecord::Migration[6.1]
  def change
    add_column :foods, :mymenu_id, :integer
  end
end
