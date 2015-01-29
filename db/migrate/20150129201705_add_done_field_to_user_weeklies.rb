class AddDoneFieldToUserWeeklies < ActiveRecord::Migration
  def change
    change_table :user_weeklies do |t|
      t.boolean :done, :default => false
    end
  end
end
