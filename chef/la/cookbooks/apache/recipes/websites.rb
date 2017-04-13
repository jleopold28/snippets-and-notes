file 'default www' do
  path '/var/www/html/index.html'
  content 'Hello World!'
end

search['node', 'role:web'].each do |node|
  puts node
end
