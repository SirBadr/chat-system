class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :chat_id
      t.text :body
      t.string :app_token

      t.timestamps
    end
  end
end
