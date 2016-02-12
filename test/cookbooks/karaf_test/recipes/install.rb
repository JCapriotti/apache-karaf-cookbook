if node['platform'] == 'ubuntu'
  execute 'apt-get update'
end

user 'someuser' do
  home      '/home/someuser'
  supports  :manage_home => true
  action    :create
end

karaf 'install karaf' do
  install_java  true
  version       node['karaf_test']['version']
  user         'someuser'
  action        :install
end

karaf_feature_repository 'hawtio' do
  version '1.4.51'
  :install
end

karaf_feature 'hawtio' do
  :install
end

karaf_user 'newuser' do
  groups    ['group1', 'group2']
  password  'ultrafubar'
  :create
end

karaf_group 'newgroup' do
  roles   ['role1', 'role2']
  :create
end