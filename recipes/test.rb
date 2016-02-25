
karaf 'test' do
  install_java  node['test']['install_java']
  source_url    node['test']['source_url']
  version       node['test']['version']
  install_path  node['test']['install_path']
  user          node['test']['user']
end
