class AddPictureToUserWeeklies < ActiveRecord::Migration
  def change
    add_column :user_weeklies, :picture, :string
  end
end
