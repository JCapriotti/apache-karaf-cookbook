resource_name :karaf_config

property :install_path, kind_of: String, default: '/usr/local'
property :client_user, kind_of: String, default: 'karaf'
property :pid, kind_of: String, required: true, name_property: true
property :property, kind_of: String, required: true
property :value, kind_of: String, default: ''

require 'chef/resource'
require 'chef/resource/bash'

default_action :list

client_command = 'bin/client'

def karaf_path
  "#{install_path}/karaf"
end 

action :list do

  bash 'install feature' do
    cwd  karaf_path
    code <<-EOH
      #{client_command} -r 20 -d 3 -u #{client_user} config:list
    EOH
  end
end

action :property_set do
#  bin/client -u karaf "config:edit com.dummy; config:property-set foo bar; config:update"
  bash 'property-set' do
    cwd  karaf_path
    code <<-EOH
      #{client_command} -r 20 -d 3 -u #{client_user} "config:edit #{pid}; config:property-set #{property} \"#{value}\"; config:update"
    EOH
  end
end

action :property_append do
#  bin/client -u karaf "config:edit com.dummy; config:property-set foo bar; config:update"
  bash 'property-append' do
    cwd  karaf_path
    code <<-EOH
      #{client_command} -r 20 -d 3 -u #{client_user} 'config:edit #{pid}; config:property-append #{property} \"'#{value}'\"; config:update'
    EOH
  end
end


action :property_delete do
#  bin/client -u karaf "config:edit com.dummy; config:property-set foo bar; config:update"
  bash 'property-delete' do
    cwd  karaf_path
    code <<-EOH
      #{client_command} -r 20 -d 3 -u #{client_user} 'config:edit #{pid}; config:property-delete #{property} ; config:update'
    EOH
  end
end

action :delete do
#  bin/client -u karaf "config:edit com.dummy; config:property-set foo bar; config:update"
  bash 'delete config' do
    cwd  karaf_path
    code <<-EOH
      #{client_command} -r 20 -d 3 -u #{client_user} 'config:delete #{pid}'
    EOH
  end
end