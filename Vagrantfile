# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # All Vagrant configuration is done here. The most common configuration
    # options are documented and commented below. For a complete reference,
    # please see the online documentation at vagrantup.com.

    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "{{ project_name|cut:"_" }}-dev"

    # Our provisioning files and scripts. Note that it is better to symlink or
    # copy files in the provisioning scripts that to copy them here. This should
    # be used only to copy files that are not in the project directory. Order is
    # important.
    config.vm.provision :file, :source => "~/.ssh/id_rsa", :destination => "/home/vagrant/.ssh/id_rsa"
    config.vm.provision :file, :source => "~/.ssh/id_rsa.pub", :destination => "/home/vagrant/.ssh/host_id_rsa.pub"
    config.vm.provision :shell, :path => "vagrant_conf/provision_root.sh"
    config.vm.provision :shell, :path => "vagrant_conf/provision_user.sh", :privileged => false
    config.vm.provision :file, :source => "~/.gitconfig", :destination => "/home/vagrant/.gitconfig"

    # Uncomment this to play around with provisioning stuff. You can comment the
    # provisioning scripts above and run vagrant provision to only run this code.
    # Generally, though, provisioniong stuff should live in the above scripts.
    # config.vm.provision :shell,
    #   inline: "cat /path/to/some/file/" # put commands in the string

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    # config.vm.box_url = "http://domain.com/path/to/above.box"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP. This is necessary to be able to mount the shared folder
    # via nfs, which improves performance.
    config.vm.network "private_network", ip: "192.168.33.10"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine.
    config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "forwarded_port", guest: 8000, host:8000
    config.vm.network "forwarded_port", guest: 5432, host:5555

    config.ssh.forward_agent = true

    # Better name for the project's shared folder (/vagrant will still work).
    # We need this: the code assumes that it is running in a directory called idonethis.
    # You can add other folders here in the same format.
    # nfs with fsc mount option improves performance, which is noticeable on git
    # commands. This is important since the prompt runs git status (~1.5s -> 0.4s)
    # config.vm.synced_folder "./", "/home/vagrant/{{ project_name }}/", type: "nfs", mount_options: ['rw', 'vers=3', 'tcp', 'fsc']
    config.vm.synced_folder "./", "/home/vagrant/{{ project_name }}/"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    config.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "2048"]

        # Don't boot with headless mode
        # vb.gui = true
    end

    # Only unused stuff below. Keep stuff that may be useful in the future here.

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    # config.ssh.forward_agent = true
end
