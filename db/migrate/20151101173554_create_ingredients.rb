class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :unit
      t.float :calories
      t.timestamps
    end
  end
end
