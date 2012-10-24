class ChangeTokSessToText < ActiveRecord::Migration
  def change
    change_column :sessions, :room_session, :text
    change_column :sessions, :user_token, :text
  end
end
