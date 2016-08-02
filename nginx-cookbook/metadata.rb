name             'nginx-cookbook'
maintainer       'ICONMEDIOS'
maintainer_email 'alan@paradojo.com'
license          'All rights reserved'
description      'Installs/Configures nginx-cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends 'apt'
depends 'php'
depends 'mariadb'
depends 'firewall'
depends 'nginx'
