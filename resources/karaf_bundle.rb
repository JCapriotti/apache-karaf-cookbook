resource_name :karaf_bundle

property :install_path, kind_of: String, default: '/usr/local'
property :bundle_name, kind_of: String, required: true, name_property: true
property :version, kind_of: String, required: true
property :wrap, kind_of: [TrueClass, FalseClass], default: false
property :start, kind_of: [TrueClass, FalseClass], default: false

default_action :install

client_command = 'bin/client -r 20 -d 3'
def karaf_path
  "#{install_path}/karaf"
end 

action :install do
  if version.empty?
    bundle_string = bundle_name
  else
    bundle_string = "#{bundle_name}/#{version}"
  end

  bundle_string = "mvn:#{bundle_string}"
  if wrap
      bundle_string = "wrap:#{bundle_string}"
  end

  command_options = ''
  if start
    command_options = '-s'
  end

  bash 'install bundle' do
    cwd  karaf_path
    code "#{client_command} \"bundle:install #{command_options} #{bundle_string}\""
  end
end
