PROJECT_PATH := $(abspath $(dir $(word 1, ${MAKEFILE_LIST})))
PROJECT_ROOT := ${PROJECT_PATH}
PROJECT_NAME := $(notdir ${PROJECT_ROOT})
BOX_NAME := $$USER/${PROJECT_NAME}
BUILD_DIR := build
BOX_PACKAGE := ${BUILD_DIR}/${PROJECT_NAME}.box
BOX_PACKAGE_PATH := ${PROJECT_PATH}/${BOX_PACKAGE}
PROVIDER_DIR := .vagrant/machines/default/vmware_fusion
DISK_MANAGER := /Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager

.env:
	@echo "PROJECT_NAME  :${PROJECT_NAME}"
	@echo "BOX_NAME      :${BOX_NAME}"
	@echo "PROJECT_ROOT  :${PROJECT_ROOT}"
	@echo "BOX_PACKAGE   :${BOX_PACKAGE}"
	@echo "DISK_MANAGER  :${DISK_MANAGER}"


all: .env release

release: clean add

clean: destroy-vm
	-rm -rf ${BUILD_DIR}

destroy-vm:
	-vagrant destroy -f

add: ${BOX_PACKAGE}
	vagrant box add --clean --provider vmware_desktop --name ${BOX_NAME} --force ${BOX_PACKAGE}

${BOX_PACKAGE}: ${PROVIDER_DIR} archive

${PROVIDER_DIR}: provision

provision: start-vm stop-vm

start-vm:
	-vagrant up

stop-vm:
	-vagrant halt

archive:
	-mkdir ${BUILD_DIR}; \
	BOX_VMX=$$(cat ${PROVIDER_DIR}/id);\
	echo BOX_VMX: $$BOX_VMX; \
	BOX_DIR=$$(dirname $$BOX_VMX); \
	echo BOX_DIR: $$BOX_DIR; \
	DISK_FILE=$$(cat $$BOX_VMX | grep scsi0.0.filename | sed -e 's/^.* = "//;s/"//'); \
	echo DISK_FILE: $$DISK_FILE; \
	DISK_PATH=$$BOX_DIR/$$DISK_FILE; \
	echo DISK_PATH: $$DISK_PATH; \
	echo Defraging : $$DISK_PATH; \
	${DISK_MANAGER} -d $$DISK_PATH; \
	echo Compacting : $$DISK_PATH; \
	${DISK_MANAGER} -k $$DISK_PATH; \
	cp -f metadata.json Vagrantfile $$BOX_DIR; \
	echo Archiving : $$BOX_DIR -> ${BOX_PACKAGE_PATH}; \
	(cd $$BOX_DIR && tar -czvf ${BOX_PACKAGE_PATH} metadata.json Vagrantfile *.vmx *.vmxf *.vmsd *.nvram *.vmdk)
