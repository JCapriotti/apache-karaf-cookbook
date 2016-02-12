resource_name :karaf_feature_repository

property :install_path, kind_of: String, default: '/usr/local'
property :client_user, kind_of: String, default: 'karaf'
property :repository_name, kind_of: String, required: true, name_property: true
property :version, kind_of: String, default: ''

default_action :install

client_command = "bin/client"
def karaf_path
  "#{install_path}/karaf"
end 

action :install do
  bash 'install feature repo' do
    cwd  karaf_path
    code <<-EOH
      #{client_command} -r 20 -d 3 -u #{client_user} feature:repo-add #{repository_name} #{version}
    EOH
  end
end
