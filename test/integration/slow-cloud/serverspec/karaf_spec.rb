require 'spec_helper'

describe 'slow-cloud' do
  it_behaves_like 'karaf_install'

  describe file('/tmp/karaf-install.log') do
    its(:content) { should match /Command not found: feature:install/ }
  end
end
