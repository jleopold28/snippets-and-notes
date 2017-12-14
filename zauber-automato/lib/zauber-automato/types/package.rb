# package type
class Package < TypeBase
  def installed?(provider = nil, version = nil)
    HashDumper.insert_hash('package', @name, 'version' => version, 'provider' => provider)
  end
end

def package(*args)
  Package.new(args.first)
end
