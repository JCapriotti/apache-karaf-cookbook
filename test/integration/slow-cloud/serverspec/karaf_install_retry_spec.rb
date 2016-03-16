require 'serverspec'
set :backend, :exec

describe file('/tmp/karaf-install.log') do
  its(:content) { should match(/Command not found: feature:install/) }
end
