class CreateUserWeeklies < ActiveRecord::Migration
  def change
    create_table :user_weeklies do |t|
      t.references :herd_weekly, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
