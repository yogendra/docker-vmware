# Docker for VMWare (Fusion / Desktop / Workstation / AppCatalyst)
## Introduction
This is a base box for docker. This is based on a Ubuntu 15.05 Box from Boxcutter.
- Box name: ```yogendra/docker-vmware```
- Source: [yogendra/docker-vmware](https://github.com/yogendra/docker-vmware)
- Atlas: [yogendra/docker-vmware](https://atlas.hashicorp.com/yogendra/boxes/docker-vmware)

## Features
* Working VMHGFS
* Latest Docker Runtime
* Easy to update
* Docker daemon configured
 * Runs at startup
 * Bound to port 2375
 * Port forwarding enabled
* Packer-less
* "Just Works"

## Basic Usage
Simple vagrant init-up should get you started.
```shell
vagrant init yogendra/docker-vmware
vagrant up --provider vmware_fusion

```

## Advanced Usage
I use this box as my docker host. I use same Vagrantfile to define my docker host and docker "vm". Example:

```ruby
# Vagrantfile
Vagrant.configure(2) do |config|
  config.vm.define "web" do |web|
    web.vm.network :forwarded_port, guest: 80, host: 80
    web.vm.hostname = "web"
    web.vm.provider "docker" do |docker|
      docker.vagrant_vagrantfile = __FILE__
      docker.vagrant_machine = "docker-host"
      docker.image = "nginx"
    end
  end
  config.vm.define "docker-host", auto_start: false do |dockerHost|
    dockerHost.vm.hostname = "docker-host"
    dockerHost.vm.box = "yogendra/docker-vmware"
  end
end

```
And fire it up: 
```shell
vagrant up web --provider docker

```
Open ```http://<docker-host-ip>/``` Voila! 

### Pro Tip
Get docker host information using ```info``` provisioner (like [below](#more-information))

```shell
vagrant provision docker-host --provision-with info
```

## Hack/Customize
You can build box from source and customize to your own preference. 

### Prerequisite

You  will need following working on your machine

1. Vagrant  >= 1.4
2. GNU make
3. VMWare Fusion/ Desktop/ AppCatalyst

### Build

Building box from source is usual checkout-cd-make:

```shell
git checkout git@github.com/yogendra/docker-vmware.git
cd docker-vmware
make
```

## More information
```shell
$ vagrant provision --provision-with info
-------------------------------------------------------------------------------
== HOST =======================================================================
Hostname        : docker /
IP Address(s)   : 192.168.28.131 172.17.0.1
Kernel Version  : Linux docker 3.19.0-15-generic #15-Ubuntu SMP Thu Apr 16 23:32:37 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
VMWare Tool Ver : 10.0.5.520 (build-3228253)
OS Information  :
Distributor ID:	Ubuntu
Description:	Ubuntu 15.04
Release:	15.04
Codename:	vivid
== DOCKER =====================================================================
Version         :
Client:
 Version:      1.9.1
 API version:  1.21
 Go version:   go1.4.3
 Git commit:   a34a1d5
 Built:        Fri Nov 20 17:56:04 UTC 2015
 OS/Arch:      linux/amd64
Server:
 Version:      1.9.1
 API version:  1.21
 Go version:   go1.4.3
 Git commit:   a34a1d5
 Built:        Fri Nov 20 17:56:04 UTC 2015
 OS/Arch:      linux/amd64
Images          :
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
Containers      :
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
-------------------------------------------------------------------------------
```
## Credits
Special thanks to [Box Cutter](http://github.com/boxcutter) for such an exhaustive range of boxes.