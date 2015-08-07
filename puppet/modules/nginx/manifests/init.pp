class nginx {

  # Install the nginx package. This relies on apt-get update
  package { 'nginx':
    ensure => 'present',
    require => Exec['apt_update'],
  }


  file { '/web/etc/nginx-sites/':
    ensure => 'directory',
  }

  file { '/web/etc/nginx.d/':
    ensure => 'directory',
  }

  file { '/web/etc/logs/':
    ensure => 'directory',
  }

  # Make sure that the nginx service is running
  service { 'nginx':
    ensure => running,
    require => Package['nginx'],
  }

  # Install nginx config
  # file { 'vagrant-nginx':
  #   path => '/etc/nginx/nginx.conf',
  #   ensure => file,
  #   require => Package['nginx'],
  #   source => 'puppet:///modules/nginx/nginx.conf',
  #   mode    => 644,
  #   owner  => root,
  #   group  => root,
  #   notify  => Service["nginx"],
  # }

  file_line { 'vagrant-nginx':
    ensure => present,
    path => '/etc/nginx/nginx.conf',
    line   => 'user vagrant;',
    match  => '^user (.+)$',
    require => Package['nginx'],
    notify  => Service["nginx"],
  }

  file_line { 'vagrant-nginx-vhosts':
    ensure => present,
    path => '/etc/nginx/nginx.conf',
    line   => "\tinclude /web/etc/nginx-sites/*;",
    after  => 'include /etc/nginx/sites-enabled/\*;$',
    require => Package['nginx'],
    notify  => Service["nginx"],
  }

  file_line { 'vagrant-nginx-configs':
    ensure => present,
    path => '/etc/nginx/nginx.conf',
    line   => "\tinclude /web/etc/nginx.d/*.conf;",
    after  => 'include /etc/nginx/conf.d/\*.conf;$',
    require => Package['nginx'],
    notify  => Service["nginx"],
  }


}
