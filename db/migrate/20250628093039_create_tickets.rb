class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.datetime :closed_at
      t.string :title
      t.text :description
      t.integer :priority, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.references :customer, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
