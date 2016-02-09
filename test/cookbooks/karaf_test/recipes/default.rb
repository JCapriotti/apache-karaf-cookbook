user 'someuser' do
  action :create
end


karaf 'install karaf' do
  install_java  true
  version       '3.0.3'
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
  roles   ['rrrrrrrrrrrrr1', 'rrrrrrrrrrrr2']
  :create
end