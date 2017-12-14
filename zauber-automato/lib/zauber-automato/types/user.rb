# user type
class User < TypeBase
  def exists?
    HashDumper.insert_hash('user', @name, 'exist' => true)
  end

  # TODO: not going to be have desired behavior for multiple group tests
  def belongs_to_group?(group)
    HashDumper.insert_hash('user', @name, 'group' => group)
  end

  def belongs_to_primary_group?(group)
    HashDumper.insert_hash('user', @name, 'primary_group' => group)
  end

  def has_uid?(uid)
    HashDumper.insert_hash('user', @name, 'uid' => uid)
  end

  def has_home_directory?(path)
    HashDumper.insert_hash('user', @name, 'homedir' => path)
  end

  def has_login_shell?(shell)
    HashDumper.insert_hash('user', @name, 'shell' => shell)
  end

  def has_authorized_key?(key)
    HashDumper.insert_hash('user', @name, 'authkey' => key)
  end
end

def user(*args)
  User.new(args.first)
end
