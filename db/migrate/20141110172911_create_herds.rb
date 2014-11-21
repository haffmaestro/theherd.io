class CreateHerds < ActiveRecord::Migration
  def change
    create_table :herds do |t|
      t.string :name
      t.string :subdomain

      t.timestamps
    end
  end
end
