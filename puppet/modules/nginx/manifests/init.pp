class nginx {

  # Install the nginx package. This relies on apt-get update
  package { 'nginx':
    ensure => 'present',
    require => Exec['apt-get update'],
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
  file { 'vagrant-nginx':
    path => '/etc/nginx/nginx.conf',
    ensure => file,
    require => Package['nginx'],
    source => 'puppet:///modules/nginx/nginx.conf',
    mode    => 644,
    owner  => root,
    group  => root,
    notify  => Service["nginx"],
  }

  # Disable the default nginx vhost
  file { 'default-nginx-disable':
    path => '/etc/nginx/sites-enabled/default',
    ensure => absent,
    require => Package['nginx'],
  }
}
