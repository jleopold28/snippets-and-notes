require 'yaml'

# class to parse temp yaml file and insert hash correctly
class HashDumper
  def self.insert_hash(type, name, *attributes)
    # does the tmp.yaml exist already? load it
    resource_hash = File.file?('tmp.yaml') ? Psych.load_file('tmp.yaml') : {}

    # does the resource type not exist? create it
    resource_hash[type] = {} unless resource_hash.key?(type)

    # does the resource name not exist? create it
    resource_hash[type][name] = {} unless resource_hash[type].key?(name)

    # append the attributes to the resource name if the attribute is not nil
    attributes[0].each { |parameter, attribute| resource_hash[type][name][parameter] = attribute unless attribute.nil? }

    # dump the hash back out to the yaml
    File.open('tmp.yaml', 'w') { |file| file.write(Psych.dump(resource_hash, indentation: 2)) }
  end
end
