name              'karaf'
maintainer        'Jason Capriotti'
maintainer_email  'jason.capriotti@gmail.com'
license           'All rights reserved'
description       'Installs/Configures karaf'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url        'https://github.com/jcapriotti/apache-karaf-cookbook'
issues_url        'https://github.com/JCapriotti/apache-karaf-cookbook/issues'
version           '0.2.1'

depends 'ark'
depends 'java'

supports 'centos'
supports 'fedora', '<= 21'
supports 'ubuntu'
