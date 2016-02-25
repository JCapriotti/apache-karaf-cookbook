resource_name :karaf_user

property :install_path, kind_of: String, default: '/usr/local'
property :user_name, kind_of: String, required: true, name_property: true
property :password, kind_of: String, required: true
property :groups, kind_of: Array, required: true

default_action :create

def users_properties_path
  "#{install_path}/karaf/etc/users.properties"
end 

action :create do
  group_string = groups.map { |group| "_g_:#{group}," }.join

  ruby_block "Update existing user #{user_name}" do
    block do
      fe = Chef::Util::FileEdit.new(users_properties_path)
      fe.search_file_replace_line(/#{user_name} = /, "#{user_name} = #{password},#{group_string}")
      fe.write_file
    end
    only_if { ::File.readlines(users_properties_path).grep(/#{user_name} = /).any? }
  end

  ruby_block "Create user #{user_name}" do
    block do
      fe = Chef::Util::FileEdit.new(users_properties_path)
      fe.insert_line_if_no_match(/#{user_name} = /, "#{user_name} = #{password},#{group_string}")
      fe.write_file
    end
    not_if { ::File.readlines(users_properties_path).grep(/#{user_name} = /).any? }
  end
end
