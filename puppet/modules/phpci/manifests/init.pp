class phpci (
    $url = 'http://phpci.local',
    $domain = 'phpci.local',
    $db_host = 'localhost',
    $db_name = 'phpci',
    $db_user = 'phpci',
    $db_password = 'phpci',
    $admin_name = 'phpci',
    $admin_email = 'phpci@localhost.com',
    $admin_password = 'phpci',
    $install_path = '/home/vagrant/phpci',
    $composer_home = '/home/vagrant',
) {
    require mysql::server
    require php
    require php::cli


    exec { 'phpci-create':
        command => "composer create-project block8/phpci ${install_path} --keep-vcs --no-dev",
        path    => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin',
        environment => "COMPOSER_HOME=${composer_home}",
        user => 'vagrant',
        creates  => "${install_path}/console",
    }


    exec { 'phpci-composer':
        command => "composer install",
        path    => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin',
        environment => "COMPOSER_HOME=${composer_home}",
        user => 'vagrant',
        cwd => $install_path,
        subscribe   => Exec['phpci-create'],
        refreshonly => true
    }

    exec { 'phpci-install':
        command => "console phpci:install --url='${url}' --db-host='${db_host}' --db-name='${db_name}' --db-user='${db_user}' --db-pass='${db_password}' --admin-name='${admin_name}' --admin-mail='${admin_email}' --admin-pass='${admin_password}'",
        path    => "/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:${install_path}",
        cwd => $install_path,
        user => 'vagrant',
        subscribe   => Exec['phpci-composer'],
        refreshonly => true,
    }

    file { "/etc/nginx/sites-enabled/${domain}.conf":
        content => template('phpci/vhost.erb'),
        ensure => present,
    }

    mysql::db { $db_name:
        ensure   => present,
        user     => $db_user,
        password => $db_password,
        host     => $db_host,
    }

    Mysql::Db[$db_name] -> Exec['phpci-create']

}
