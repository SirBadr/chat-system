class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.string :app_token
      t.integer: chat_id
      t.integer :messages_count

      t.timestamps
    end
  end
end
