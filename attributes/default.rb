default['karaf']['version'] = '3.0.3'
default['karaf']['url'] = ''
default['karaf']['install_path'] = '/usr/local'
default['karaf']['install_java'] = true

default['karaf']['feature_repos'] = {'hawtio' => '1.4.51'}
default['karaf']['features'] = ['hawtio']

# If installing Java, default to these settings 
default['java']['install_flavor'] = 'oracle'
default['java']['jdk_version'] = '7'
default['java']['set_etc_environment'] = true
default['java']['oracle']['accept_oracle_download_terms'] = true
