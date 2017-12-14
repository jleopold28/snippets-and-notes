# group type
class Group < TypeBase
  def exists?
    HashDumper.insert_hash('group', @name, 'exist' => true)
  end

  def has_gid?(gid)
    HashDumper.insert_hash('group', @name, 'gid' => gid)
  end
end

def group(*args)
  Group.new(args.first)
end
