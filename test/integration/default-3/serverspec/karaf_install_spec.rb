require 'serverspec'
require 'karaf_install'
set :backend, :exec

describe 'karaf-3' do
  it_behaves_like 'karaf_install'
end
