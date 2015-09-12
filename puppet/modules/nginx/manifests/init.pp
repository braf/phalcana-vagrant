class nginx (
  $user = 'www-data'
) {

  # Install the nginx package. This relies on apt-get update
  package { 'nginx':
    ensure => 'present',
    require => Exec['apt_update'],
  }


  file { [
    '/web/etc/nginx-sites/',
    '/web/etc/nginx.d/',
    '/web/etc/logs/'
    ]:
    ensure => 'directory',
  }


  # Make sure that the nginx service is running
  service { 'nginx':
    ensure => running,
    require => Package['nginx'],
  }

  file_line { 'user-nginx':
    ensure => present,
    path => '/etc/nginx/nginx.conf',
    line   => 'user ${user};',
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
