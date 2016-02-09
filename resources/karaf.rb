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

  execute 'start karaf' do
    cwd   karaf_path
    user  user
    command <<-EOF
      #{start_command}
      sleep 20s
    EOF
  end
    
  execute 'install karaf service wrapper' do
    command <<-EOF
      #{client_command} -u karaf feature:install service-wrapper
      #{client_command} -u karaf wrapper:install
    EOF
    cwd  karaf_path
    not_if  { ::File.exists?("#{karaf_path}/bin/karaf-service") }
  end

  execute 'stop karaf' do
    cwd   karaf_path
    user  user
    command <<-EOF
      #{stop_command}
      sleep 10s
    EOF
  end

  link '/etc/init.d/karaf-service' do
    to "#{karaf_path}/bin/karaf-service"
    link_type :symbolic
  end

  ruby_block 'modify user that karaf runs as' do
    block do
      fe = Chef::Util::FileEdit.new("#{karaf_path}/bin/karaf-service")
      fe.search_file_replace_line(/#RUN_AS_USER=/, "RUN_AS_USER=#{user}")
      fe.write_file
    end
    only_if { ::File.readlines("#{karaf_path}/bin/karaf-service").grep(/#RUN_AS_USER=/).any? }
  end

  service 'karaf-service' do
    supports :status => true, :start => true, :stop => true, :restart => true
    action [:enable, :start]
  end


  execute 'Wait' do
    command <<-EOF
      sleep 10s
    EOF
  end


end

