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

end
