class AddHerdIdToActivity < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.integer :herd_id
    end
  end
end
