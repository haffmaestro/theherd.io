class AddTodoistApiTokenToUserModel < ActiveRecord::Migration
  def change
    add_column :users, :todoist_api_token, :string, :default => false
  end
end
