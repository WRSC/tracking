class RemovePasswordFromMembers < ActiveRecord::Migration
  def change
    remove_column :members, :password, :string
  end
end
