require 'spec_helper'

describe 'karaf::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs java when attribute is true' do
    chef_run.node.set['karaf']['install_java'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('java')
  end

  it 'installs java when attribute is false' do
    chef_run.node.set['karaf']['install_java'] = false
    chef_run.converge(described_recipe)
    expect(chef_run).to_not include_recipe('java')
  end


  it 'downloads and extracts karaf using default values' do
    expect(chef_run).to put_ark('karaf').with(
      url: 'http://archive.apache.org/dist/karaf/3.0.3/apache-karaf-3.0.3.tar.gz', 
      path: '/usr/local',
    )
  end

end
