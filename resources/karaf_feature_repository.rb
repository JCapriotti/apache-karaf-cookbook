resource_name :karaf_feature_repository

property :install_path, kind_of: String, default: '/usr/local'
property :repository_name, kind_of: String, required: true, name_property: true
property :version, kind_of: String, default: ''

default_action :install

client_command = 'bin/client -r 20 -d 3'

def karaf_path
  "#{install_path}/karaf"
end 

action :install do
  bash 'install feature repo' do
    cwd  karaf_path
    code "#{client_command} feature:repo-add #{repository_name} #{version}"
  end
end
