# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
# Install some other stuff we need
sudo apt-get update
sudo apt-get install -y apt-transport-https \
						ca-certificates \
						wget \
						software-properties-common \
						curl \
						make \
						git \
						mercurial \
						build-essential \
						zip
# Install Python dependencies
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
sudo add-apt-repository ppa:jonathonf/python-3.6
sudo apt-get update
sudo apt-get install -y python3.6
wget https://bootstrap.pypa.io/get-pip.py
sudo python3.6 get-pip.py
# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
# Executing the Docker Command Without Sudo
sudo usermod -aG docker vagrant
# Install Compose
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# Install Gcloud
# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Update the package list and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk -y
# Install kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
sudo snap install helm --classic
SCRIPT

Vagrant.configure(2) do |config|
   config.vm.provider "virtualbox" do |v|
	 v.memory = 1024
   end
   config.vm.box_check_update = false
   config.vm.box = "bento/ubuntu-16.04"
   config.vm.synced_folder ".", "/vagrant", disabled: false, create: true

   # Port Forwarding
   config.vm.network "forwarded_port", guest: 8080, host: 8080
   config.vm.network "forwarded_port", guest: 8081, host: 8081
   config.vm.network "forwarded_port", guest: 5000, host: 5000
   config.vm.network "forwarded_port", guest: 5672, host: 5672

   config.vm.provision "shell", inline: $script
end