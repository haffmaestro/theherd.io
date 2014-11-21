class CreateFocusAreas < ActiveRecord::Migration
  def change
    create_table :focus_areas do |t|
      t.string :name
      t.references :user, index: true

      t.timestamps
    end
  end
end
