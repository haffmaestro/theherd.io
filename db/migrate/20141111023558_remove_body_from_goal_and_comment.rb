class RemoveBodyFromGoalAndComment < ActiveRecord::Migration
  def change
    remove_column :goals, :body, :string
    remove_column :comments, :body, :string

    add_column :goals, :body, :text
    add_column :comments, :body, :text
  end
end
