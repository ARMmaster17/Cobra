class AddApiReadonly < ActiveRecord::Migration
  def up
    add_column :keys, :read_only, :boolean, default: true
  end
  def down
    remove_column :keys, :read_only, :boolean, default: true
  end
end