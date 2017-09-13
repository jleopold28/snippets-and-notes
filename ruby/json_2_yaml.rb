def json_2_yaml(file)
  require 'json'
  File.write("#{file}.yaml", Psych.dump(JSON.parse(File.read("#{file}.json"))), indentation: 2)
end
