#!/bin/bash
source config.sh
source functions.sh

#main
ARRAY=()

#1 retrieve name-instance value(s) from /storage-container/ resource 
echo "display the name(s) of /storage-container/ resource instances"
ARRAY=$(getResourceValues $RESOURCE_SC $KEY_NAME)
echo "resource:${RESOURCE_SC} key:${KEY_NAME} value(s):${ARRAY[@]}"
echo

#2 retrieve name-instance value(s) from /images/ resource 
echo "display the name(s) of /image/ resource instances"
ARRAY=$(getResourceValues $RESOURCE_IM $KEY_NAME)
echo "resource:${RESOURCE_IM} key:${KEY_NAME} value(s):${ARRAY[@]}"
echo

#3 retrieve "default-container" storage-container uuid from /storage-container/ resource
echo "retrieve the default container uuid from /storage-container/ resource"
DEFAULT_SC_UUID=$(getResourceEntityValue $RESOURCE_SC $KEY_NAME $DISK_CONTAINER_NAME $KEY_STORAGE_CONTAINER_UUID)
echo "resource:${RESOURCE_SC} key:${KEY_STORAGE_CONTAINER_UUID} value:${DEFAULT_SC_UUID}"
echo

#4 retrieve "ISO" storage-container uuid from /storage-container/ resource
echo "retrieve the ISO container uuid from /storage-container/ resource"
ISO_SC_UUID=$(getResourceEntityValue $RESOURCE_SC $KEY_NAME $ISO_CONTAINER_NAME $KEY_STORAGE_CONTAINER_UUID)
echo "resource:${RESOURCE_SC} key:${KEY_STORAGE_CONTAINER_UUID} value:${ISO_SC_UUID}"
echo

#5 retrieve "windows" vmdisk-uuid from /images/ resource
echo "retrieve the vmdisk uuid from /images/ resource for windows iso image"
WIN_VMDISK_UUID=$(getResourceEntityValue $RESOURCE_IM $KEY_NAME $OS_IMAGE_NAME $KEY_VMDISK_UUID)
echo "resource:${RESOURCE_IM} key:${KEY_VMDISK_UUID} value:${WIN_VMDISK_UUID}"
echo

#6 retrieve "ngt" vmdisk-uuid from /images/ resource
echo "retrieve the vmdisk uuid from /images/ resource for virt-io iso image"
NGT_VMDISK_UUID=$(getResourceEntityValue $RESOURCE_IM $KEY_NAME $NGT_IMAGE_NAME $KEY_VMDISK_UUID)
echo "resource:${RESOURCE_IM} key:${KEY_VMDISK_UUID} value:${NGT_VMDISK_UUID}"
echo

#7 create vm
echo "create the vm"
RESPONSE=$(createResource $RESOURCE_VM GEN_VM_CREATE_MSG $WIN_VMDISK_UUID $DEFAULT_SC_UUID $NGT_VMDISK_UUID 10737418240)
echo "response: ${RESPONSE}"
echo

quiesce 15

#8 retrieve vm uuid single resource-instance value
echo "retrieve the vm uuid"
VM_UUID=$(getResourceValue $RESOURCE_VM ".${KEY_ENTITY_ARRAY}[0].${KEY_VM_UUID}")
echo "resource:${RESOURCE_VM} key:${KEY_VM_UUID}: value:${VM_UUID}"
echo

#9 set power-state "on" 
echo "power the vm on"
RESPONSE=$(setPowerState $RESOURCE_VM GEN_VM_POWER_MSG $VM_UUID "ON")
echo "response: ${RESPONSE}"
echo

quiesce 15

#10 set power-state "off" 
echo "power the vm off"
RESPONSE=$(setPowerState $RESOURCE_VM GEN_VM_POWER_MSG $VM_UUID "OFF")
echo "response: ${RESPONSE}"
echo

quiesce 15

#11 delete resource
echo "delete the vm"
RESPONSE=$(deleteResource $RESOURCE_VM $VM_UUID)
echo "response: ${RESPONSE}"
echo

#uncomment the following to display formatted json using jq
#RESULT=$(getResource $RESOURCE_IM)
#echo $RESULT | jq '.'

#endmain

