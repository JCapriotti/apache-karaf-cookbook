karaf 
=====
This cookbook installs [Apache Karaf](http://karaf.apache.org/).

Usage
-----
Use the provided resources to install karaf and configure users and features.

Requirements
------------
* java cookbook
* ark cookbook

### Platform
* Tested on CentOS 6.6 and Ubuntu 14.04 (via Kitchen)

## Resources

### `karaf`
```ruby
karaf 'install karaf' do
  install_java  true
  version       '4.0.4'
  user         'someuser'  
  action        :install
end

```
#### Actions
* `:install` - Installs Karaf and the karaf-service wrapper feature, and starts the service.
* `:remove` - Removes Karaf and the karaf-service wrapper

#### Attributes
* `install_java` - Whether or not to install Java. *(default: true)*
* `source_url` - Optional URL to download the Karaf file tar file from.
* `version` - The version of Karaf to install.
* `install_path` - Optional install path. *(default: /usr/local)*
* `user` - The user to run karaf-service as. *(default: root)*
* `retry_count` - The number of times to retry when performing Karaf client actions. This is important for slower platforms but generally shouldn't need to be changed. *(default: 20)*
* `retry_delay` - The number of seconds to wait when retrying a Karaf client action. This is important for slower platforms but generally shouldn't need to be changed. *(default: 3)*

> **Note:**
> When setting the user to run Karaf as, it is assumed the user is already configured properly. When installing features, Maven may use a local repository for the user, which may require a home directory to be set. 

### `karaf_feature_repository`
```ruby
karaf_feature_repository 'hawtio' do
  version 		'1.4.51'
  client_user	'karaf'
  :install
end
```

#### Actions
* `:install` - Installs the specified feature repository.

#### Attributes
* `install_path` - The path to the installation folder. Needs to match the value in `karaf`. Will be cleaned-up/deprecated once a link is added from this resource to `karaf`. *(default: '/usr/local')*
* `client_user` - The user to run the karaf client as. *(default: karaf)*
* `repository_name` - The name of the repository to add. *(name attribute)*
* `version` - The version of the repository to add. *(default: '')*


### `karaf_feature`
```ruby
karaf_feature 'hawtio' do
  :install
end

```
#### Actions
* `:install` - Installs the specified feature.

#### Attributes
* `install_path` - The path to the installation folder. Needs to match the value in `karaf`. Will be cleaned-up/deprecated once a link is added from this resource to `karaf`. *(default: '/usr/local')*
* `client_user` - The user to run the karaf client as. *(default: karaf)*
* `feature_name` - The name of the feature to add. *(name attribute)*
* `version` - The version of the feature to add. *(default: '')*


### `karaf_bundle`
```ruby
karaf_bundle 'com.fasterxml.jackson.core/jackson-core' do
  version '2.4.3'
  :install
end

```
#### Actions
* `:install` - Installs the specified bundle.

#### Attributes
* `install_path` - The path to the installation folder. Needs to match the value in `karaf`. Will be cleaned-up/deprecated once a link is added from this resource to `karaf`. *(default: '/usr/local')*
* `client_user` - The user to run the karaf client as. *(default: karaf)*
* `bundle_name` - The name of the feature to add. *(name attribute)*
* `version` - The version of the feature to add. *(default: '')*
* `wrap` - If this bundle needs to be wrapped. Prepends . *(default: false)*


### `karaf_user`
Manages the users defined in user.properties
```ruby
karaf_user 'newuser' do
  groups    ['group1', 'group2']
  password  'ultrafubar'
  :create
end
```

#### Actions
* `:create` - Creates or updates the specified karaf user.

#### Attributes
* `install_path` - The path to the installation folder. Needs to match the value in `karaf`. Will be cleaned-up/deprecated once a link is added from this resource to `karaf`. *(default: '/usr/local')*
* `user_name` - The name of the user to create. *(name attribute)*
* `password` - The password for the user.
* `groups` - An array of groups to add the user to.


### `karaf_group`
Manages the groups defined in user.properties
```ruby
karaf_group 'newgroup' do
  roles   ['role1', 'role2']
  :create
end
```

#### Actions
* `:create` - Creates or updates the specified karaf group.

#### Attributes
* `install_path` - The path to the installation folder. Needs to match the value in `karaf`. Will be cleaned-up/deprecated once a link is added from this resource to `karaf`. *(default: '/usr/local')*
* `group_name` - The name of the group to create. *(name attribute)*
* `roles` - An array of roles to add the group to.

#### Notes
This resource automatically adds the (apparently) required `group` role to the group definition. That is:
```ruby
karaf_group 'newgroup' do
  roles   ['role1', 'role2']
  :create
end
```

Will generate this line in user.properties:

    _g_\:newgroup = group,role1,role2,

Contributing
------------
1. Fork the repository on Github
1. Create a named feature branch (like `add_component_x`)
1. Write your change
1. Write tests for your change
1. Run the tests, ensuring they all pass
1. Run foodcritic and rubocop to make sure code is clean.
1. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Jason Capriotti
