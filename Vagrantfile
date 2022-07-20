# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  #K3D development box
  config.vm.define "k3d" do |k3d|
    #Get a curated box from my server
    k3d.vm.box_url = "http://lama00.lcybernetics.space/vagrant/nixfocal64.json"
    k3d.vm.box = "nix/focal64"
    #Forward the default jupyter port
    k3d.vm.network "forwarded_port", guest: 8888, host: 8888, host_ip: "127.0.0.1"


    k3d.vm.synced_folder "infra/salt", "/srv/salt"
    k3d.vm.synced_folder "notebooks", "/srv/jupyter/notebooks"

    k3d.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = true
      # Customize the amount of memory on the VM:
      vb.memory = "6144"
      vb.cpus = 4
    end

    k3d.vm.provision :salt do |salt|
      #salt.masterless = true
      salt.minion_config = "infra/salt-config.yml"
      salt.run_highstate = true
      salt.verbose = true 
    end
  end
  #K8s-Control VM
  config.vm.define "k8sControl" do |k8sC|
    k8sC.vm.box_url = "http://lama00.lcybernetics.space/vagrant/nixfocal64.json"
    k8sC.vm.box = "nix/focal64"
    k8sC.vm.hostname = "k8s-control"
    k8sC.vm.allow_hosts_modification = false
    k8sC.vm.synced_folder "infra/salt", "/srv/salt"
    k8sC.vm.synced_folder "notebooks", "/srv/jupyter/notebooks"
    k8sC.vm.network "private_network", ip: "10.0.10.10", subnet_mask: "255.255.255.0", virtualbox__intnet: "k8s"
    #Forward the default jupyter port
    k8sC.vm.network "forwarded_port", guest: 8888, host: 8889, host_ip: "127.0.0.1"
    k8sC.vm.provider "virtualbox" do |vb|
            # Display the VirtualBox GUI when booting the machine
            vb.gui = true
            # Customize the amount of memory on the VM:
            vb.memory = "4028"
            vb.cpus = 2
    end
    k8sC.vm.provision :salt do |saltC|
      #salt.masterless = true
      saltC.minion_config = "infra/k8scontrol-config.yml"
      saltC.run_highstate = true
      saltC.verbose = true 
    end
  end
  #K8s Worker 1 VM
  config.vm.define "k8sWorker1" do |k8sW1|
    k8sW1.vm.box_url = "http://lama00.lcybernetics.space/vagrant/nixfocal64.json"
    k8sW1.vm.box = "nix/focal64"
    k8sW1.vm.hostname = "k8s-worker1"
    k8sW1.vm.network "private_network", ip: "10.0.10.11", subnet_mask: "255.255.255.0", virtualbox__intnet: "k8s"
    k8sW1.vm.allow_hosts_modification = false 
    k8sW1.vm.synced_folder "infra/salt", "/srv/salt"
    k8sW1.vm.provider "virtualbox" do |vb|
            # Display the VirtualBox GUI when booting the machine
            vb.gui = true
            # Customize the amount of memory on the VM:
            vb.memory = "4028"
            vb.cpus = 2
    end
    k8sW1.vm.provision :salt do |salt|
      salt.masterless = true
      salt.minion_config = "infra/k8sworker1-config.yml"
      salt.run_highstate = true
      salt.verbose = true 
    end
  end
  #K8s Worker 2 VM
  config.vm.define "k8sWorker2" do |k8sW2|
    k8sW2.vm.box_url = "http://lama00.lcybernetics.space/vagrant/nixfocal64.json"
    k8sW2.vm.box = "nix/focal64"
    k8sW2.vm.hostname = "k8s-worker2"
    k8sW2.vm.network "private_network", ip: "10.0.10.12", subnet_mask: "255.255.255.0", virtualbox__intnet: "k8s"
    k8sW2.vm.allow_hosts_modification = false
    k8sW2.vm.synced_folder "infra/salt", "/srv/salt"
    k8sW2.vm.provider "virtualbox" do |vb|
            # Display the VirtualBox GUI when booting the machine
            vb.gui = true
            # Customize the amount of memory on the VM:
            vb.memory = "4028"
            vb.cpus = 2
    end
    k8sW2.vm.provision :salt do |salt|
      #salt.masterless = true
      salt.minion_config = "infra/k8sworker2-config.yml"
      salt.run_highstate = true
      salt.verbose = true 
    end
  end
  config.vm.define "ansibleController" do |ans|
    ans.vm.box_url = "http://lama00.lcybernetics.space/vagrant/nixfocal64.json"
    ans.vm.box = "nix/focal64"
    ans.vm.hostname = "ansible-control"
    ans.vm.allow_hosts_modification = true 
    ans.vm.synced_folder "infra/ansible", "/srv/ansible"
    ans.vm.provider "virtualbox" do |vb|
            # Display the VirtualBox GUI when booting the machine
            vb.gui = true
            # Customize the amount of memory on the VM:
            vb.memory = "2048"
            vb.cpus = 2
    end
    ans.vm.provision :salt do |salt|
      #salt.masterless = true
      salt.minion_config = "infra/k8sworker2-config.yml"
      salt.run_highstate = true
      salt.verbose = true 
    end
  end

end
