require 'serverspec'
require 'karaf_install'
set :backend, :exec

describe 'slow-cloud' do
  it_behaves_like 'karaf_install'
end
