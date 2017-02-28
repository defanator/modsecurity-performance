# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  mem  = 1024
  host = RbConfig::CONFIG['host_os']

  # provide more resources to vm
  if host =~ /darwin/
    mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 2
  end

  # provider specific settings
  config.vm.provider "virtualbox" do |vbox|
    vbox.memory = mem
  end

  config.vm.box = "ubuntu/yakkety64"
  config.vm.hostname = "vagrant"

  # use NFS for performant file sharing
  config.vm.network :private_network, ip: '192.168.50.50'
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  # mount states and pillars to the appropriate locations
  config.vm.synced_folder "states/", "/srv/salt/", type: "nfs"
  config.vm.synced_folder "pillars/", "/srv/pillar/", type: "nfs"

  config.vm.provision :salt do |salt|
    salt.minion_config     = "minion"
    salt.install_type      = "stable"
    salt.bootstrap_options = "-n -X"
    salt.masterless        = true
    salt.run_highstate     = true
  end
end
