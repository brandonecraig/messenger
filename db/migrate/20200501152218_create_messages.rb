class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :body
      t.string :sender
      t.string :recipient

      t.timestamps
    end
  end
end
