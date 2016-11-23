require 'serverspec'
require 'karaf_install'
set :backend, :exec

describe 'slow-cloud' do
  include_examples 'karaf_install'
end
