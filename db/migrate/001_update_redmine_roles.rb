
class UpdateRedmineRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :project_id, :integer
  end

  def self.down
    remove_column :roles, :project_id
  end
end
