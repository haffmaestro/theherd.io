class AddYearWeekNumToHerdWeekly < ActiveRecord::Migration
  def change
    remove_column :herd_weeklies, :date, :date
    add_column :herd_weeklies, :year, :integer
    add_column :herd_weeklies, :week, :integer
  end
end
