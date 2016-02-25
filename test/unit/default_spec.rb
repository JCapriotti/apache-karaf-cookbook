require 'spec_helper'

describe 'karaf::test' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['karaf']) do |node|
      node.set['test']['install_java'] = true
      node.set['test']['source_url'] = ''
      node.set['test']['version'] = ''
      node.set['test']['install_path'] = ''
      node.set['test']['user'] = ''
    end.converge(described_recipe)
  end

  it 'installs java when attribute is true' do
    chef_run.node.set['test']['install_java'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('java')
  end

  it 'does not install java when attribute is false' do
    chef_run.node.set['test']['install_java'] = false
    chef_run.converge(described_recipe)
    expect(chef_run).to_not include_recipe('java')
  end

  it 'downloads and extracts karaf using default values' do
    expect(chef_run).to put_ark('karaf').with(
      url: 'http://archive.apache.org/dist/karaf/3.0.3/apache-karaf-3.0.3.tar.gz', 
      path: '/usr/local',
    )
  end

  it 'creates users.properties with default karaf user' do
    chef_run.node.override['karaf']['users'] = 
    {
      'karaf' => {
        'password' => 'karaf',
        'groups' => {
          'admingoup' => true,
          'another_group' => true,
        },
      },
    }
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/usr/local/karaf/etc/users.properties')
      .with_content { |content|
        expect(content).to include("karaf = karaf,_g_:admingroup,\n")
      }
  end

  it 'creates users.properties and does not put karaf user in a group set to false' do
    chef_run.node.set['karaf']['users']['karaf']['groups']['admingroup'] = false
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/usr/local/karaf/etc/users.properties')
      .with_content { |content|
        expect(content).to_not include('karaf = karaf,_g_:admingroup,')
      }
  end
end
