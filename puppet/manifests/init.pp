$packages = hiera_array('packages')
package { $packages:
  ensure => present,
}

$directories = hiera_array('directories')
file { $directories:
  ensure => 'directory',
}

hiera_include('classes')


Apt::Ppa <| |> -> Class['apt::update'] -> ::Php::Extension <| |>
