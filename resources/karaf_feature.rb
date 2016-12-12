resource_name :karaf_feature

property :install_path, kind_of: String, default: '/usr/local'
property :feature_name, kind_of: String, required: true, name_property: true
property :version, kind_of: String, default: ''

default_action :install

client_command = 'bin/client -r 20 -d 3'
def karaf_path
  "#{install_path}/karaf"
end 

action :install do
  if version.empty?
    feature_string = feature_name
  else
    feature_string = "#{feature_name}/#{version}"
  end

  bash 'install feature' do
    cwd  karaf_path
    code "#{client_command} feature:install #{feature_string}"
  end
end
