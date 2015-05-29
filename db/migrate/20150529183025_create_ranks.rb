class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer :traffic_rank
      t.references :domain, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
