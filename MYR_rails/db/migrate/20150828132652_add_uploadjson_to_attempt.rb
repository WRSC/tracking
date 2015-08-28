class AddUploadjsonToAttempt < ActiveRecord::Migration
  def change
		add_column    :attempts, :uploadjson, :string    
	end
end
