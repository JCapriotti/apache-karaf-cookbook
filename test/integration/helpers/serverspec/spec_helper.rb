require 'serverspec'
set :backend, :exec

shared_examples_for 'karaf_install' do
  describe 'karaf' do
    it 'has hawtio listening on port 8181' do
      expect(port(8181)).to be_listening
    end

    it 'has a running service of karaf-service' do
      expect(service('karaf-service')).to be_running
    end
  end
end
