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
log_file = '/tmp/karaf-install.log'
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
    
  bash 'install karaf service wrapper' do
    cwd   karaf_path
    user  new_resource.user
    code <<-EOH
      echo ">>>>>>> Start at " $(date --rfc-3339=seconds) &>> #{log_file}

      ## START
      #{start_command} &>> #{log_file}
      
      ## feature:install service-wrapper
      COUNTER=0
      LAST_EXIT=1
      until [ "$COUNTER" -eq "#{retry_count}" ]; do
        #{client_command} -u karaf feature:install service-wrapper &>> #{log_file}
        LAST_EXIT=$?
        echo "last exit code: " $LAST_EXIT &>> #{log_file}
        if [ "$LAST_EXIT" -eq "0" ]; then 
          break
        fi
        let COUNTER=COUNTER+1
        echo "retry " $COUNTER  &>> #{log_file}
        sleep #{retry_delay}
      done

      while true; do
        if [ "$(bin/client -u karaf 'feature:list -i' | grep service-wrapper -c)" -ge 1 ] ; then
          echo "service-wrapper found" &>> #{log_file}
          break
        else
          echo "service-wrapper NOT found" &>> #{log_file}
        fi
      done

      ## wrapper:install
      #{client_command} -u karaf wrapper:install &>> #{log_file}
      while true ; do
        if [ -a #{service_wrapper_file} ] ; then
          echo "karaf-service found" &>> #{log_file}
          break
        else
          echo "karaf-service NOT found" &>> #{log_file}
        fi
      done

      ## STOP
      #{stop_command} &>> #{log_file}
      sleep 10s
    EOH
    not_if { ::File.exist?("#{karaf_path}/#{service_wrapper_file}") }
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
    # systemd
    service "#{karaf_path}/bin/karaf.service" do
      action    :enable
    end
  else
    # SysV + Ubuntu (Karaf seems to recommend using SysV for Upbuntu)
    link '/etc/init.d/karaf' do
      to "#{karaf_path}/bin/karaf-service"
      link_type :symbolic
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
    code <<-EOH
      #{stop_command}
    EOH
  end

  link '/etc/init.d/karaf-service' do
    ignore_failure  true
    action :delete
  end

  directory karaf_path do
    recursive true
    action    :delete
  end
end
