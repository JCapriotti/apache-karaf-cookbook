#
# Cookbook Name:: karaf
# Recipe:: default
#

include_recipe "java"
include_recipe "ark"


if node['karaf']['url'].empty?
  karaf_url = "http://www.apache.org/dyn/closer.cgi/karaf/#{node['karaf']['version']}/apache-karaf-#{node['karaf']['version']}.tar.gz"
else
  karaf_url = node['karaf']['url']
end

ark "karaf" do
  url karaf_url
  path node['karaf']['install_path']
  action :put
end
