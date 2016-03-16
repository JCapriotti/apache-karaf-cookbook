require 'serverspec'
set :backend, :exec

describe command('/usr/local/karaf/bin/client -u karaf "realm-manage --realm karaf; user-list"') do
  its(:stdout) { should match create_user_list_regex('karaf', 'admingroup', 'admin') }
  its(:stdout) { should match create_user_list_regex('karaf', 'admingroup', 'manager') }
  its(:stdout) { should match create_user_list_regex('karaf', 'admingroup', 'viewer') }
  its(:stdout) { should match create_user_list_regex('karaf', 'admingroup', 'systembundles') }
  its(:stdout) { should match create_user_list_regex('newuser', 'newgroup', 'role1') }
  its(:stdout) { should match create_user_list_regex('newuser', 'newgroup', 'role2') }
  its(:stdout) { should match create_user_list_regex('newuser', 'anothergroup', 'viewer') }
  its(:stdout) { should match create_user_list_regex('newuser', 'anothergroup', 'manager') }
end

def create_user_list_regex(user, group, role)
  /#{user}\s*\|\s*#{group}\s*\|\s*#{role}/
end