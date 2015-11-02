class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.belongs_to :recipe, index: true
      t.integer :stepnumber
      t.string :name
      t.text :description
      t.string :image
      t.timestamps
    end
  end
end