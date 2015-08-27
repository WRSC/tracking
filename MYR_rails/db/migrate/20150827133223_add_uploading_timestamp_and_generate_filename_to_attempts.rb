class AddUploadingTimestampAndGenerateFilenameToAttempts < ActiveRecord::Migration
  def change
			add_column    :attempts, :upload_timestamp, :string
			add_column    :attempts, :generated_filename, :string  
	end
end
