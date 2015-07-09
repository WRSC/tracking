class AddRemeberDigestToMembers < ActiveRecord::Migration
  def change
    add_column :members, :remember_digest, :string
  end
end
