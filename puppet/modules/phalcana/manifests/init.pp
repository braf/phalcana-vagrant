class phalcana(
  $path     = '/web/www/',
  $projects = {}
){
  require nginx
  require php


  ssh::resource::known_hosts { 'hosts':
      hosts => 'bitbucket.org,github.com',
      user  => 'vagrant'
  }

  create_resources(phalcana::project, $projects)

}
