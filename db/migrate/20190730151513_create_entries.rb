class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.text :title
      t.text :body
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :entries, [:user_id, :created_at]
  end
end
