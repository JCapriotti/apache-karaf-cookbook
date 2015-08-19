#
# Cookbook Name:: karaf
# Recipe:: default
#

install_path = node['karaf']['install_path']
karaf_path = "#{install_path}/karaf"
start_command = "#{karaf_path}/bin/start"
client_command = "#{karaf_path}/bin/client"

if node['karaf']['install_java']
  include_recipe 'java'
end

if node['karaf']['url'].empty?
  karaf_url = "http://archive.apache.org/dist/karaf/#{node['karaf']['version']}/apache-karaf-#{node['karaf']['version']}.tar.gz"
else
  karaf_url = node['karaf']['url']
end

ark "karaf" do
  url karaf_url
  path install_path
  action :put
end

execute 'start karaf' do
  command <<-EOF
    #{start_command}
    sleep 5
  EOF
end


execute 'install karaf service wrapper' do
  command <<-EOF
    #{client_command} -u karaf feature:install service-wrapper
    #{client_command} -u karaf wrapper:install
  EOF
  not_if  { ::File.exists?("#{karaf_path}/bin/karaf-service") }
end

link '/etc/init.d/karaf-service' do
  to "#{karaf_path}/bin/karaf-service"
  link_type :symbolic
end

service 'karaf-service' do
  supports :status => true, :restart => true
  action :start
end

# Install feature repos
node['karaf']['feature_repos'].each_pair do |name, version|
  execute 'install feature repo' do
    command <<-EOF
      #{client_command} -u karaf feature:repo-add #{name} #{version}
    EOF
  end
end

# Install features
node['karaf']['features'].each do |name|
  execute 'install feature' do
    command <<-EOF
      #{client_command} -u karaf feature:install #{name}
    EOF
  end
end

