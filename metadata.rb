name              'karaf'
maintainer        'Jason Capriotti'
maintainer_email  'jason.capriotti@gmail.com'
license           'All rights reserved'
description       'Installs/Configures karaf'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url        'https://github.com/JCapriotti/apache-karaf-cookbook'
issues_url        'https://github.com/JCapriotti/apache-karaf-cookbook/issues'
version           '3.1.0'

depends 'ark'
depends 'java'

supports 'centos'
supports 'ubuntu'
