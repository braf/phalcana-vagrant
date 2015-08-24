class frontend (
    $node_modules = ['bower', 'grunt-cli', 'gulp'],
    $ruby_modules = ['sass']
){
    require nodejs

    package { $node_modules:
        provider => 'npm'
    }

    package { $ruby_modules:
        provider => 'gem'
    }
}
