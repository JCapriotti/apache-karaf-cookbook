require 'spec_helper'

describe 'config' do
  it_behaves_like 'karaf_install'

  describe file('/usr/local/karaf/etc/com.test.propset.cfg') do
    its(:content) { should match(/foo = bar/) }
  end

  describe file('/usr/local/karaf/etc/com.test.propappend.cfg') do
    its(:content) { should match(/foo = bar, append/) }
  end  

  describe file('/usr/local/karaf/etc/com.test.propdelete.cfg') do
    its(:content) { should_not match(/myprop =/) }
  end  

  describe file('/usr/local/karaf/etc/com.test.deleteme.cfg') do
    it { should_not exist }
  end    
  
  describe file('/usr/local/karaf/etc/org.apache.karaf.shell.cfg') do
    its(:content) { should match(/sshIdleTimeout = 1800001/) }    
  end      
  
end
