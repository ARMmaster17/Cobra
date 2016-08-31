class CreateBase < ActiveRecord::Migration
  def up
    create_table :sites do |t|
  	  t.string :full_name
  	  t.string :short_name
  	  t.timestamps
  	end
  	create_table :zones do |t|
  	    t.belongs_to :site, index: true
  	    t.string :full_name
  	    t.string :short_name
  	    t.timestamps
  	end
  	create_table :lots do |t|
  	    t.belongs_to :zone, index: true
  	    t.string :full_name
  	    t.string :short_name
  	    t.integer :total_spaces, default: 0
  	    t.boolean :is_staff_only, default: false
  	    t.boolean :is_restricted_access, default: false
  	    t.boolean :is_trackable, default: false
  	    t.timestamps
  	end
  end
  def down
    drop_table :lots
    drop_table :zones
    drop_table :sites
  end
end