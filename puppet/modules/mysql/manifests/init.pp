# vagrant/puppet/modules/mysql/manifests/init.pp
class mysql {

  # Install mysql
  package { ['mysql-server']:
    ensure => present,
    require => Exec['apt_update'],
  }

  service { 'mysql':
    ensure  => running,
    require => Package['mysql-server'],
  }

  file { '/etc/mysql/my.cnf':
    source  => 'puppet:///modules/mysql/my.cnf',
    mode    => 644,
    owner  => root,
    group  => root,
    require => Package['mysql-server'],
    notify  => Service['mysql'],
  }

  exec { 'set-mysql-password':
    unless  => 'mysqladmin -uroot -proot password root',
    command => 'mysqladmin -uroot password root',
    path    => ['/bin', '/usr/bin'],
    require => Service['mysql'];
  }
}
