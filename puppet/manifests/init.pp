
package { [
    'vim',
    'git',
    'python-software-properties',
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

include nginx, mysql, apt, stdlib, ::php, timezone

Apt::Ppa <| |> -> Class['apt::update'] -> ::Php::Extension <| |>
