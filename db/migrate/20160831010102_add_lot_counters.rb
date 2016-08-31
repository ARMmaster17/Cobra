class AddLotCounters < ActiveRecord::Migration
  def up
    add_column :lots, :used_spaces, :integer
  end
  def down
    remove_column :lots, :used_spaces, :integer
  end
end