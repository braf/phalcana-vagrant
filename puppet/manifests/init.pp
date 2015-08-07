
package { [
    'vim',
    'git',
    'python-software-properties',
    'man',
    'ntp',
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

class { 'timezone':
    timezone => 'Europe/London',
}


include nginx, mysql, apt, stdlib, ::php

Apt::Ppa <| |> -> Class['apt::update'] -> ::Php::Extension <| |>
