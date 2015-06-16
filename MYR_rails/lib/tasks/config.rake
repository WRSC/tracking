namespace :config do 
	desc "Load config"
	task(:load) do
		ruby "#{Rails.root}/lib/generator/ruby_script/config_static.rb"
		#ruby "#{Rails.root}/lib/generator/ruby_script/config_dynamic.rb"
		puts "Load config completed"
	end
end