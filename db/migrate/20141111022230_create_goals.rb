class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :body
      t.boolean :done
      t.datetime :due_date
      t.references :focus_area, index: true

      t.timestamps
    end
  end
end
