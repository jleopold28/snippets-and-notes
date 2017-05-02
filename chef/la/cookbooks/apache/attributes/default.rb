default['apache']['sites']['localhost'] = { 'site_title' => 'Website coming soon.', 'port' => 80, 'domain' => 'localdomain' }
default['apache']['sites']['localhost2'] = { 'site_title' => 'Website also coming soon.', 'port' => 80, 'domain' => 'localdomain2' }
default['apache']['sites']['localhost3'] = { 'site_title' => 'Website coming soon too.', 'port' => 80, 'domain' => 'localdomain2' }

default['author']['name'] = 'not me'

case node['platform']
when 'centos' then default['apache']['package'] = 'httpd'
when 'ubuntu' then default ['apache']['package'] = 'apache2'
end
