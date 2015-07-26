exec { 'apt-get update':
  path => '/usr/bin',
}

package { 'vim':
  ensure => present,
}

package { 'git':
  ensure => present,
}

file { '/web/':
  ensure => 'directory',
}

file { '/web/www/':
  ensure => 'directory',
}

include nginx, php, mysql

