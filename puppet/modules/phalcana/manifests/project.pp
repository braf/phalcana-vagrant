define phalcana::project (
  $repo,
  $domain,
  $ensure = 'present',
  $composer_home = '/home/vagrant',
  $databases = {},
) {
    $install_path = "${::phalcana::path}${name}"

    if $ensure == 'present' {

        exec { "${name}-clone":
            command => "git clone ${repo} ${name}",
            path    => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin',
            cwd => $::phalcana::path,
            user => 'vagrant',
            creates => $install_path,
            require => Ssh::Resource::Known_hosts['hosts'],
        }



    } else {
        file { $name:
            ensure => $ensure,
            force => true,
        }
    }

    file { "/etc/nginx/sites-enabled/${domain}.conf":
        content => template('phalcana/vhost.erb'),
        ensure => $ensure,
    }

    exec { "${name}-composer":
        command => "composer install",
        path    => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin',
        environment => "COMPOSER_HOME=${composer_home}",
        user => 'vagrant',
        cwd => $install_path,
        subscribe   => Exec["${name}-clone"],
        refreshonly => true
    }

    create_resources('mysql::db', $databases, {
        ensure => $ensure,
        host   => 'localhost',
    })

}
