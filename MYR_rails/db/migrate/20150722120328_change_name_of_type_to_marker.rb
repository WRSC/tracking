class ChangeNameOfTypeToMarker < ActiveRecord::Migration
  def change
		remove_column :markers, :type, :string
		add_column :markers, :mtype, :string
  end
end
