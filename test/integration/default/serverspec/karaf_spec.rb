require 'serverspec'

# Required by serverspec
set :backend, :exec

describe "karaf" do

  it "has hawtio listening on port 8181" do
    expect(port(8181)).to be_listening
  end

  it "has a running service of karaf-service" do
    expect(service("karaf-service")).to be_running
  end

end
