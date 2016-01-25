karaf 
=====
This cookbook installs [Apache Karaf](http://karaf.apache.org/).

Usage
-----
Override attributes with your desired values and include the `karaf` recipe.

Requirements
------------
* java cookbook
* ark cookbook

### Platform
* Tested on Fedora 22 and CentOS 6.5

Attributes
----------
See `attributes/default.rb` for default values.

* `node['karaf']['version']` - The version to install, defaults to `'3.03'`
* `node['karaf']['url']` - Overrides the URL to download the karaf from. Otherwise http://archive.apache.org/dist/karaf/&lt;version&gt;/apache-karaf-&lt;version&gt;.tar.gz" is used.
* `node['karaf']['install_path']` - The path to install to, defaults to `'/usr/local'`
* `node['karaf']['install_java']` - Whether or not to install Java, defaults to `true`
* `node['karaf']['service_user']` - The user to run Karaf as, not set by default.
* `node['karaf']['feature_repos']` - A hash of feature repos to install. Allows you to specify the  repository name as the key and version as the value. Defaults to `'hawtio'` / `'1.4.51'`.
* `node['karaf']['features']` - An array of the features to install. Defaults to `'hawtio'`.

The following attributes control the default Java cookbook settings

* `node['java']['install_flavor']` - Defaults to `'oracle'`
* `node['java']['jdk_version']` - Defaults to `'7'`
* `node['java']['set_etc_environment']` - Defaults to `true`
* `node['java']['oracle']['accept_oracle_download_terms']` - Defaults to `true`

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Jason Capriotti
