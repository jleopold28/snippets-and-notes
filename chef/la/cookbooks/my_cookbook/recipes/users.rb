search(:users, 'comment:admin*').each do |data|
  user data['id'] do
    comment data['comment']
    uid data['uid']
    gid data['gid']
    home data['home']
    shell data['shell']
  end
end
