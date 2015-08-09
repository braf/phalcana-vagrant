class timezone (
  $timezone = 'UTC',
) {

  exec { 'check_timezone':
    command     => "echo '${timezone}' > /etc/timezone",
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    unless      => "grep '${timezone}' /etc/timezone",
  }

  exec { '/etc/localtime':
    command => "cp /usr/share/zoneinfo/${timezone} /etc/localtime",
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    subscribe   => Exec['check_timezone'],
    refreshonly => true,
  }

  exec { 'update_timezone':
    command     => 'dpkg-reconfigure -f  noninteractive tzdata',
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    subscribe   => Exec['/etc/localtime'],
    refreshonly => true,
  }
}
