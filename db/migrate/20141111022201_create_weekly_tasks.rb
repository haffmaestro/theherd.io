class CreateWeeklyTasks < ActiveRecord::Migration
  def change
    create_table :weekly_tasks do |t|
      t.string :body
      t.boolean :done
      t.datetime :due_date
      t.references :section, index: true

      t.timestamps
    end
  end
end
