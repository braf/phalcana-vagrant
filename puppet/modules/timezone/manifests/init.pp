class timezone (
  $timezone = 'UTC',
) {

  file { '/etc/timezone':
    ensure  => 'present',
    content => "{$timezone}",
    before => File['/etc/localtime'],
    show_diff => true,
  }

  file { '/etc/localtime':
    ensure => 'link',
    target => "/usr/share/zoneinfo/${timezone}",
  }

  exec { 'update_timezone':
    command     => 'dpkg-reconfigure --no-reload -f  noninteractive tzdata',
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    subscribe   => File['/etc/timezone'],
    refreshonly => true,
  }
}
