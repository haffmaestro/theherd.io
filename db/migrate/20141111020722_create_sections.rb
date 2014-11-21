class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.references :user_weekly, index: true
      t.references :focus_area, index: true

      t.timestamps
    end
  end
end
