resource_name :karaf

property :install_java, kind_of: [TrueClass, FalseClass], default: true
property :source_url, kind_of: String, default: ''
property :version, kind_of: String
property :install_path, kind_of: String, default: '/usr/local'
property :user, kind_of: String, default: 'root'
property :retry_count, kind_of: Integer, default: 20
property :retry_delay, kind_of: Integer, default: 3

default_action :install

start_command = 'bin/start'
stop_command = 'bin/stop'
service_wrapper_file = 'bin/karaf-service'

# The root folder of the karaf install
def karaf_path
  "#{install_path}/karaf"
end 

# The call to the karaf client, with defaulted retry parameters
def client_command
  "bin/client -r #{retry_count} -d #{retry_delay}"
end


action :install do

  include_recipe 'java' if install_java

  if source_url.nil? || source_url.empty?
    source_url = "http://archive.apache.org/dist/karaf/#{version}/apache-karaf-#{version}.tar.gz"
  end

  log 'karaf version' do
    message "karaf version #{version}"
    level  :info
  end

  ark 'karaf' do
    url   source_url
    path  install_path
    owner user
    action :put
  end

  bash 'start karaf' do
    cwd   karaf_path
    user  new_resource.user
    code  start_command
  end

  bash 'install karaf service wrapper feature' do
    cwd          karaf_path
    user         new_resource.user
    code         "#{client_command} feature:install service-wrapper"
    retries      retry_count
    retry_delay  retry_delay
  end

  bash 'install karaf wrapper' do
    cwd          karaf_path
    user         new_resource.user
    code         "#{client_command} wrapper:install"
    retries      retry_count
    retry_delay  retry_delay
    not_if       "bin/client -u karaf 'feature:list -i' | grep -v grep | grep service-wrapper -c"
  end

  ruby_block 'modify user that karaf runs as' do
    block do
      fe = Chef::Util::FileEdit.new("#{karaf_path}/#{service_wrapper_file}")
      fe.search_file_replace_line(/#RUN_AS_USER=/, "RUN_AS_USER=#{user}")
      fe.write_file
    end
    only_if { ::File.readlines("#{karaf_path}/#{service_wrapper_file}").grep(/#RUN_AS_USER=/).any? }
  end

  # Create the service
  if node['platform'] == 'centos' and node['platform_version'] >= '7'
    # systemd - avoid using a symlink and just copy the service file, then enable.
    remote_file '/etc/systemd/system/karaf.service' do
      source "file://#{karaf_path}/bin/karaf.service"
    end
    service 'karaf.service' do
      action    :enable
    end
  else
    # SysV + Ubuntu (Karaf seems to recommend using SysV for Ubuntu)
    link '/etc/init.d/karaf' do
      to         "#{karaf_path}/bin/karaf-service"
      link_type  :symbolic
    end

    service 'karaf' do
      supports  :status => true, :start => true, :stop => true, :restart => true
      action    :enable
    end
  end

  service 'karaf' do
    action    :restart
  end
end


action :remove do
  service 'karaf' do
    ignore_failure  true
    action          :stop
  end

  bash 'Stop karaf' do
    ignore_failure  true
    cwd             karaf_path
    user            new_resource.user
    code            stop_command
  end

  link '/etc/init.d/karaf' do
    ignore_failure  true
    action :delete
  end

  link '/etc/systemd/system/karaf' do
    ignore_failure  true
    action :delete
  end

  file '/etc/systemd/system/karaf.service' do
    ignore_failure  true
    action          :delete
  end

  directory karaf_path do
    recursive true
    action    :delete
  end
end
