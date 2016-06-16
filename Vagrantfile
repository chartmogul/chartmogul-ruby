# -*- mode: ruby -*-
# vi: set ft=ruby :

# Check for the plugins required to run
required_plugins = %w(vagrant-vbguest vagrant-librarian-chef-nochef)

plugins_to_install = required_plugins.select { |plugin| !Vagrant.has_plugin? plugin }
unless plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort 'Installation of one or more plugins has failed. Aborting.'
  end
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "172.28.128.22"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder '.', '/vagrant', type: 'nfs'

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = "1536"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision 'shell-default', type: 'shell', inline: <<-SHELL
    sudo echo "LANGUAGE=en_US.UTF-8" > /etc/default/locale
    sudo echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
    sudo echo "LANG=en_US.UTF-8" >> /etc/default/locale
    sudo echo "LC_TYPE=en_US.UTF-8" >> /etc/default/locale
    sudo apt-get -y update --fix-missing
    sudo apt-get -y upgrade
    sudo apt-get -y install build-essential patch
    sudo apt-get -y install libgmp-dev zlib1g-dev
    sudo apt-get -y install git-core
    sudo apt-get -y install htop
  SHELL

  config.vm.provision 'chef-default', type: 'chef_solo' do |chef|
    chef.cookbooks_path = ['cookbooks']
    chef.add_recipe 'rvm::user'

    chef.json = {
      rvm: {
        user_rubies: ['ruby-2.3.0'],
        user_default_ruby: 'ruby-2.3.0',
        user_installs: [{ user: 'vagrant' }],
        user_global_gems: [{ name: 'bundler' }]
      }
    }
  end
end
