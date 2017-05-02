#
# Cookbook:: my-cookbook
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

['cowsay', 'tree', 'bind-utils'].each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe 'my_cookbook::php'
include_recipe 'my_cookbook::security'
include_recipe 'my_cookbook::users'
include_recipe 'my_cookbook::groups'
include_recipe 'my_cookbook::mysql'
