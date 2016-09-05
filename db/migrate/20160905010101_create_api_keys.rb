class CreateApiKeys < ActiveRecord::Migration
  def up
    create_table :keys do |t|
  	  t.string :key_identifier
  	  t.string :key_secret
  	  t.integer :rate_limit, default: -1
  	  t.integer :requests_used, default: 0
  	  t.timestamps
  	end
  end
  def down
    drop_table :keys
  end
end