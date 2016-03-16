
execute 'apt-get update' if node['platform'] == 'ubuntu'

user 'someuser' do
  home      '/home/someuser'
  supports  :manage_home => true
  action    :create
end

karaf 'install karaf' do
  install_java  true
  version       node['karaf_test']['version']
  user          'someuser'
  action        :install
end

karaf_feature_repository 'hawtio' do
  version '1.4.51'
  :install
end

karaf_feature 'hawtio' do
  :install
end

karaf_bundle 'com.fasterxml.jackson.core/jackson-core' do
  version '2.4.3'
  :install
end

karaf_user 'newuser' do
  groups    ['newgroup', 'anothergroup']
  password  'ultrafubar'
  :create
end

karaf_group 'newgroup' do
  roles   ['role1', 'role2']
  :create
end

karaf_group 'anothergroup' do
  roles   ['viewer', 'manager']
  :create
end
