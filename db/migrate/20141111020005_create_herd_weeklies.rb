class CreateHerdWeeklies < ActiveRecord::Migration
  def change
    create_table :herd_weeklies do |t|
      t.date :date
      t.references :herd, index: true

      t.timestamps
    end
  end
end
