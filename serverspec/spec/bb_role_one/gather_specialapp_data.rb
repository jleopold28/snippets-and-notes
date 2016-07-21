require 'yaml'
require_relative '../spec_helper.rb'

data = YAML.load_file(File.expand_path('../specialapp_template.yaml', __FILE__))

describe "Gathering data from #{host_inventory['fqdn']} for Specialapp." do
  specialapp_version = ''

  it 'Gathering deployed Specialapp version.' do
    specialapp_version = command('/query/database/for specialapp_version').stdout.chomp
  end

  it 'Gathering package versions.' do
    data['packages'].each do |package, _|
      version = command("rpm -q #{package} --queryformat '%{version}-%{release}' | /bin/grep -v 'is not installed'").stdout.chomp
      data['packages'][package]['version'] = version.to_s
    end
  end

  it 'Gathering war file sizes.' do
    data['war_files'].each do |war, attributes|
      size = command("/bin/ls -l #{attributes['file']} | /bin/awk '{print $5}'").stdout.chomp
      data['war_files'][war]['size'] = size.to_i
    end
  end

  it 'Gathering number of files in library directories.' do
    data['lib_dirs'].each do |lib_dir, attributes|
      num = command("/bin/ls -l #{attributes['dir']} | /bin/egrep -c ^-").stdout.chomp
      data['lib_dirs'][lib_dir]['num'] = num.to_s
    end
  end

  it 'Placing gathered information into yaml data file for checks on all servers.' do
    File.open(File.expand_path("../specialapp_#{specialapp_version}.yaml", __FILE__), 'w') do |file|
      file.write(Psych.dump(data, indentation: 2))
    end
  end
end
