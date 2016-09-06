class DropKey < ActiveRecord::Migration
  def up
    drop_table :keys
  end
  def down
    create_table :keys do |t|
  	  t.string :key_identifier
  	  t.string :key_secret
  	  t.integer :rate_limit, default: -1
  	  t.integer :requests_used, default: 0
  	  t.timestamps
  	end
  end
end