
package { [
    'vim',
    'git',
    'python-software-properties',
    'man',
    'ntp,'
    ]:
  ensure => present,
}

file { '/web/':
  ensure => 'directory',
}

file { '/web/etc/':
  ensure => 'directory',
}

file { '/web/www/':
  ensure => 'directory',
}

include nginx, php, mysql, apt, stdlib

