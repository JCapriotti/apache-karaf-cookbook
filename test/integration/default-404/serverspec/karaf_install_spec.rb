require 'serverspec'
require 'karaf_install'
set :backend, :exec

describe 'karaf-404' do
  include_examples 'karaf_install'
end
