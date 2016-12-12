shared_examples 'karaf_install' do

  describe port(8181) do
    it { should be_listening }
  end

  describe service('karaf') do
    it { should be_enabled }
    it { should be_running }
  end

  # TODO This check of family really needs to check only for CentOS...
  describe service('karaf'), :if => (os[:family] == 'redhat' && os[:release] >= '7') do
    it { should be_running.under('systemd') }
  end

  describe file('/usr/local/karaf/bin/karaf-service') do
    its(:content) { should match /RUN_AS_USER=someuser/ }
  end

  describe file('/usr/local/karaf/data/karaf.pid') do
    it { should be_owned_by 'someuser' }
  end

  describe command('/usr/local/karaf/bin/client bundle:list Jackson-core') do
    its(:stdout) { should match /Active/ }
  end

end
