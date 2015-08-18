class AddUploadxmlToAttempts < ActiveRecord::Migration
  def change
		add_column :attempts, :uploadxml, :string
  end
end
