class AddTodoistApiTokenToUserModel < ActiveRecord::Migration
  def change
    add_column :users, :todoist_api_token, :string
  end
end
