# vagrant/puppet/modules/php/manifests/init.pp
class php {

  # Install the php5-fpm and php5-cli packages
  package { ['php5-fpm',
             'php5-cli']:
    ensure => present,
    require => Exec['apt_update'],
  }

  # Install fpm config
  # file { 'fpm-config':
  #   path => '/etc/php5/fpm/pool.d/www.conf',
  #   ensure => file,
  #   require => Package['php5-fpm'],
  #   source => 'puppet:///modules/php/www.conf',
  #   mode    => 644,
  #   owner  => root,
  #   group  => root,
  #   notify  => Service["php5-fpm"],
  # }

  file_line { 'php5-fpm-user':
    ensure => present,
    path => '/etc/php5/fpm/pool.d/www.conf',
    line   => 'user = vagrant',
    match  => '^user = (.+)$',
    require => Package['php5-fpm'],
    notify  => Service["php5-fpm"],
  }

  file_line { 'php5-fpm-group':
    ensure => present,
    path => '/etc/php5/fpm/pool.d/www.conf',
    line   => 'group = vagrant',
    match  => '^group = (.+)$',
    require => Package['php5-fpm'],
    notify  => Service["php5-fpm"],
  }

  file_line { 'php5-fpm-socket':
    ensure => present,
    path => '/etc/php5/fpm/pool.d/www.conf',
    line   => 'listen = /var/run/php5-fpm.sock',
    match  => '^listen = 127.0.0.1:9000$',
    require => Package['php5-fpm'],
    notify  => Service["php5-fpm"],
  }


  # Make sure php5-fpm is running
  service { 'php5-fpm':
    ensure => running,
    require => Package['php5-fpm'],
  }


  apt::ppa { 'ppa:phalcon/stable': }

  # Install phalcon
  package { 'php5-phalcon':
    ensure => present,
    require => [apt::ppa['ppa:phalcon/stable'], Package['php5-fpm']],
  }




  # php build packages
  # package { ['php5-dev', 'php5-mysql', 'gcc', 'libpcre3-dev', 'make']:
  #   ensure => present,
  #   require => Exec['apt-get update'],
  # }

  # clone
  # exec { 'phalcon-clone':
  #   command => 'git clone --depth=1 git://github.com/phalcon/cphalcon.git',
  #   cwd => '/home/vagrant',
  #   path => '/usr/bin',
  #   creates => "/home/vagrant/cphalcon/build/install",
  #   require => Package['php5-dev', 'php5-mysql', 'gcc', 'libpcre3-dev', php5-fpm, php5-cli, 'make'],
  # }


  # # install
  # exec { 'phalcon-install':
  #   command => '/home/vagrant/cphalcon/build/install',
  #   cwd => '/home/vagrant/cphalcon/build',
  #   require => Exec['phalcon-clone'],
  #   timeout => 0,
  #   unless => '/usr/bin/php -i 2>/dev/null | grep -c "phalcon => enabled" > /dev/null 2>&1',
  # }


  # Add extension config
  file { 'phalcon-configure':
    path => '/etc/php5/conf.d/30-phalcon.ini',
    ensure => file,
    source => 'puppet:///modules/php/30-phalcon.ini',
    mode    => 644,
    owner  => root,
    group  => root,
    require => package['php5-phalcon'],
    notify  => Service["php5-fpm"],
  }

  # imagemagick
  package { 'php5-imagick':
    ensure => present,
    require => Package['php5-cli', 'php5-fpm'],
    notify  => Service["php5-fpm"],
  }

  # gd
  package { 'php5-gd':
    ensure => present,
    require => Package['php5-cli', 'php5-fpm'],
    notify  => Service["php5-fpm"],
  }

  # curl
  package { 'php5-curl':
    ensure => present,
    require => Package['php5-cli', 'php5-fpm'],
    notify  => Service["php5-fpm"],
  }

  # memcached
  package { ['memcached','php5-memcached']:
    ensure => present,
    require => Package['php5-cli', 'php5-fpm'],
    notify  => Service["php5-fpm"],
  }

}
