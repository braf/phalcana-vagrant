
Vagrant.configure(2) do |config|

    config.vm.hostname = "vagrant"
    config.vm.box = "ericmann/trusty64"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # config.vm.network "forwarded_port", guest: 80, host: 8080

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    # config.vm.network "private_network", ip: "192.168.2.10"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network", ip: "192.168.1.80"

    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder "../../web/www", "/web/www"
    config.vm.synced_folder "../../web/etc", "/web/etc"
    config.vm.synced_folder "puppet/modules", "/etc/puppet/modules"
    config.vm.synced_folder "puppet/data", "/etc/puppet/data"


    config.vm.provision "shell",
         path: "puppet-bootstrap/ubuntu.sh"


    config.vm.provision :puppet do |puppet|
        puppet.hiera_config_path = "puppet/hiera.yaml"
        puppet.manifests_path = 'puppet/manifests'
        puppet.module_path = 'puppet/modules'
        puppet.manifest_file = 'init.pp'
    end

    config.vm.provision "shell", run: "always",
        inline: "service nginx restart && service php5-fpm restart"
end
