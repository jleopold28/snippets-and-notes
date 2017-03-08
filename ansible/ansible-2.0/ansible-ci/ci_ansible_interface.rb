require 'yaml'
# PLACEHOLDER: grab list of stuff from jenkins or wherever

# the resources hash population code block could be combo'd with the task_array population code block, but leaving separate now for generality
resources = {}
# capture from first line
version = /.*Release-(.*) Stuff/.match(line).captures[0]
File.foreach('ci.txt') do |line|
  # TODO: actual formatted list and include extra zip info parameters
  resources[num] = { type: /(.*)\s([A-Za-z]+)/.match(line).captures[1].downcase, name: /(.*)\s([A-Za-z]+)/.match(line).captures[0] }
end

# PLACEHOLDER: grab scripts and zips and dump in roles/deploy/files/

task_array = []
resources.each do |_, value|
  case value[:type]
  when 'rpm' then task_array.push('yum' => "name=#{value[:name]} state=present")
  when 'script' then task_array.push('script' => "name=roles/deploy/files/#{value[:name]}")
  when 'zip'
    task_array.push('unarchive' => "src=roles/deploy/files/#{value[:name]} dest=#{value[:path]}")
    task_array.push('command' => value[:post].to_s)
  else task_array.push('debug' => "msg='#{value[:type]} was not identified as a valid resource type.'")
  end
end

File.open('roles/deploy/tasks/main.yml', 'w') do |file|
  file.write("\#Version: #{version}")
  file.write(Psych.dump(task_array, indentation: 2))
end
