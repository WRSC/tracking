require 'yaml'
require 'erb'
puts "config_dynamic.rb Start"

PATHFILE_YAML = "lib/generator/config_variables/"
PATHFILE_IN ="lib/generator/template/"
PATHFILE_OUT = "app/helpers/"

FILENAME_YAML = "config.yaml"
FILENAME_IN = "test.html.erb"
FILENAME_OUT = "test_output.rb"

data = YAML::load(File.open(PATHFILE_YAML+FILENAME_YAML))
myVar1=data["bonjour"]
myVar2=data["ppppp"]["toto"]
myVar3= data["CSS"]
inputfile = File.open(PATHFILE_IN+FILENAME_IN)
outfile = File.open(PATHFILE_OUT+FILENAME_OUT,"w")

renderer = ERB.new(inputfile.read)
output = renderer.result()
outfile.write(output)

outfile.close
inputfile.close

puts "config_dynamic.rb End"