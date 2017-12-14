# file type
class ZMFile < TypeBase
  def exist?
    HashDumper.insert_hash('file', @name, 'exist' => true)
  end

  def file?
    HashDumper.insert_hash('file', @name, 'file' => true)
  end

  def directory?
    HashDumper.insert_hash('file', @name, 'directory' => true)
  end

  def block_device?
    HashDumper.insert_hash('file', @name, 'block_device' => true)
  end

  def symlink?
    HashDumper.insert_hash('file', @name, 'symlink' => true)
  end

  def mode?(mode)
    HashDumper.insert_hash('file', @name, 'mode' => mode)
  end

  def owned_by?(owner)
    HashDumper.insert_hash('file', @name, 'owner' => owner)
  end

  def grouped_into?(group)
    HashDumper.insert_hash('file', @name, 'group' => group)
  end

  def linked_to?(target)
    HashDumper.insert_hash('file', @name, 'target' => target)
  end

  def mounted?(mount_attr = nil)
    HashDumper.insert_hash('file', @name, 'mount' => true, 'mount_attr' => mount_attr)
  end

  def to_s
    "File '#{name}'"
  end
end

def file(*args)
  ZMFile.new(args.first)
end
