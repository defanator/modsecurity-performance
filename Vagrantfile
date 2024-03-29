# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  host = RbConfig::CONFIG['host_os']
  cpus = [2, `getconf _NPROCESSORS_ONLN`.to_i / 2].max

  # provide more resources to vm
  if host =~ /darwin/
    mem = [4096, `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 2].min
  elsif host =~ /linux/
    mem = [cpus * 512, `awk '/MemTotal/ {print $2}' /proc/meminfo`.to_i / 1024 / 2].min
  end

  config.vm.box = "generic/ubuntu2004"
  config.vm.hostname = "vagrant"

  # use NFS for performant file sharing
  config.vm.network :private_network, type: "dhcp"

  # mount states and pillars to the appropriate locations
  config.vm.synced_folder "states/", "/srv/salt/"
  config.vm.synced_folder "pillars/", "/srv/pillar/"

  # provider specific settings
  config.vm.provider "virtualbox" do |vbox, override|
    vbox.cpus = cpus
    vbox.memory = mem
  end

  config.vm.provider :libvirt do |libvirt, override|
    libvirt.cpus = cpus
    libvirt.memory = mem
    libvirt.driver = "kvm"
    libvirt.cpu_mode = "host-passthrough"
  end

  config.vm.provision :salt do |salt|
    salt.minion_config     = "minion"
    salt.install_type      = "stable"
    salt.bootstrap_options = "-n -X"
    salt.masterless        = true
    salt.run_highstate     = true
  end

  config.vm.define "default", primary: true do |default|
  end

  config.vm.define "debian10", autostart: false do |debian10|
    debian10.vm.box = "debian/buster64"
  end
end
