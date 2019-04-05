Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"

  config.vm.network "forwarded_port", guest: 80, host: 8001
  config.vm.network "forwarded_port", guest: 3306, host: 3806

  config.vm.network "private_network", ip: "192.168.10.10"

  config.vm.synced_folder "./", "/vagrant", create: true
  config.vm.synced_folder "./projects", "/var/www", nfs: true, create: true

  config.vm.provision "shell" do |s|
    s.path = "bootstrap.sh"
  end

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "4096"
     vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
     vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"] #remove this if machine is too slow
  end

end
