Vagrant.configure(2) do |config|
	config.vm.box = "boxcutter/ubuntu1504"
	config.vm.hostname = "docker"
  config.vm.box = "boxcutter/ubuntu1504"
  config.vm.box_check_update = true
  config.vm.network "forwarded_port", guest: 2375, host: 2375

  config.ssh.insert_key = false

  config.vm.provider "vmware_fusion" do |vmf|
    vmf.gui = false
    vmf.vmx['memsize'] = 512
    vmf.vmx['numvcpus'] = 2
  end
  config.vm.provider "vmware_appcatalyst" do |ac|
		ac.cpus = 2
		ac.memory = '512'
	end

  config.vm.provision "docker-install", type: "docker"

  config.vm.provision "docker-config", type: "shell", inline: <<-SHELL
    mkdir -p /etc/systemd/system/docker.service.d
    cat <<CONF >/etc/systemd/system/docker.service.d/custom.conf
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// -H tcp://0.0.0.0:2375

CONF
    systemctl daemon-reload
    systemctl restart docker
    systemctl enable docker
    systemctl status docker
  SHELL

  config.vm.provision "info", type: "shell", run: "always", inline: <<-SHELL
    cat <<Information
-------------------------------------------------------------------------------
== HOST =======================================================================
Hostname        : $(hostname) / $(hostname -A)
IP Address(s)   : $(hostname -I)
Kernel Version  : $(uname -a)
VMWare Tool Ver : $(vmware-toolbox-cmd -v)
OS Information  :
$(lsb_release -a)

== DOCKER =====================================================================
Version         :
$(docker version)

Images          :
$(docker images)

Containers      :
$(docker ps -a)
-------------------------------------------------------------------------------
Information
  SHELL

end
