resource_name :karaf_group

property :install_path, kind_of: String, default: '/usr/local'
property :group_name, kind_of: String, required: true, name_property: true
property :roles, kind_of: Array, required: true

default_action :create

def users_properties_path
  "#{install_path}/karaf/etc/users.properties"
end 

action :create do
  role_string = roles.join(',')

  ruby_block "Update existing group #{group_name}" do
    block do
      fe = Chef::Util::FileEdit.new(users_properties_path)
      fe.search_file_replace_line(/#{group_name} = /, "_g_\\:#{group_name} = group,#{role_string}")
      fe.write_file
    end
    only_if { ::File.readlines(users_properties_path).grep(/#{group_name} = /).any? }
  end

  ruby_block "Create group #{group_name}" do
    block do
      fe = Chef::Util::FileEdit.new(users_properties_path)
      fe.insert_line_if_no_match(/#{group_name} = /, "_g_\\:#{group_name} = group,#{role_string}")
      fe.write_file
    end
    not_if { ::File.readlines(users_properties_path).grep(/#{group_name} = /).any? }
  end
end
