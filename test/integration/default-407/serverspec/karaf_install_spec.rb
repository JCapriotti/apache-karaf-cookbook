require 'serverspec'
require 'karaf_install'
set :backend, :exec

describe 'karaf-latest' do
  include_examples 'karaf_install'
end

