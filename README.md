# Docker for VMWare*
This is a base box for docker. This is based on a Ubuntu 15.05 Box from Boxcutter. 

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

## Prerequisite
You  will need following working on your machine
1. Vagrant  >= 1.4

2. GNU make

3. VMWare Fusion/ Desktop/ AppCatalyst

## How to build

Building box from source is 2 simple steps:

1. Checkout
```shell
git checkout git@github.com/yogendra/docker-vmware.git
cd docker-vmware
```

2. Build using make
```shell
make
```


## Credits
Special thanks to [Box Cutter](http://github.com/boxcutter) for such an exhaustive range of boxes.