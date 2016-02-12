resource_name :karaf

property :install_java, kind_of: [TrueClass, FalseClass], default: true
property :source_url, kind_of: String
property :version, kind_of: String
property :install_path, kind_of: String, default: '/usr/local'
property :user, kind_of: String, default: 'root'

default_action :install

start_command = "bin/start"
stop_command = "bin/stop"
client_command = "bin/client"
service_command = "bin/karaf-service"

def karaf_path
  "#{install_path}/karaf"
end 

action :install do
  if install_java
    include_recipe 'java'
  end

  if source_url == nil || source_url.empty?
    source_url = "http://archive.apache.org/dist/karaf/#{version}/apache-karaf-#{version}.tar.gz"
  end

  ark 'karaf' do
    url   source_url
    path  install_path
    owner user
    action :put
  end
    
  bash 'install karaf service wrapper' do
    cwd   karaf_path
    user  new_resource.user
    code <<-EOH
      #{start_command}
      #{client_command} -r 20 -d 3 -u karaf feature:install service-wrapper
      #{client_command} -r 20 -d 3 -u karaf wrapper:install
      #{stop_command}
    EOH
    not_if do ::File.exists?("#{karaf_path}/#{service_command}") end
  end

  link '/etc/init.d/karaf-service' do
    to "#{karaf_path}/#{service_command}"
    link_type :symbolic
  end

  ruby_block 'modify user that karaf runs as' do
    block do
      fe = Chef::Util::FileEdit.new("#{karaf_path}/#{service_command}")
      fe.search_file_replace_line(/#RUN_AS_USER=/, "RUN_AS_USER=#{user}")
      fe.write_file
    end
    only_if { ::File.readlines("#{karaf_path}/#{service_command}").grep(/#RUN_AS_USER=/).any? }
  end

  service 'karaf-service' do
    supports :status => true, :start => true, :stop => true, :restart => true
    action [:enable, :restart]
  end

end


action :remove do

  service 'karaf-service' do
    ignore_failure  true
    action          :stop
  end

  bash 'Stop karaf' do
    ignore_failure  true
    cwd             karaf_path
    user            new_resource.user
    code <<-EOH
      #{stop_command}
    EOH
  end

  link '/etc/init.d/karaf-service' do
    action :delete
  end

  directory karaf_path do
    recursive true
    action    :delete
  end

end