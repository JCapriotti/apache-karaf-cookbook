resource_name :karaf_feature

property :install_path, kind_of: String, default: '/usr/local'
property :client_user, kind_of: String, default: 'karaf'
property :feature_name, kind_of: String, required: true, name_property: true
property :version, kind_of: String, default: ''

default_action :install

client_command = 'bin/client'
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
    code <<-EOH
      #{client_command} -r 20 -d 3 -u karaf feature:install #{feature_string}
    EOH
  end
end
