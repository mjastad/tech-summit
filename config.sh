#!/bin/bash

#image and container instance-name settings
DISK_CONTAINER_NAME="default-container"
ISO_CONTAINER_NAME="ISO"
NGT_IMAGE_NAME="Virt-IO"
OS_IMAGE_NAME="Windows"

#task status
RUNNING="Running"
QUEUED="Queued"
SUCCEEDED="Succeeded"

#content-type
CT="Content-Type:application/json"
ACCEPT="Accept: application/json"

#user and password credentials for prism session
USER="admin"
PASSWD="passw0rd"

#host - cvm (ip), prism (server port)
IPADDR="10.68.69.102"
PORT="9440"

#abs services
ABS="/PrismGateway/services/rest/v2.0"
SERVICE_URL="https://${IPADDR}:${PORT}/${ABS}"
RESPONSE_CODE="%{http_code}\n"

#resource
RESOURCE_VM_PWR_STATE="/set_power_state/"
RESOURCE_VM="/vms/"
RESOURCE_SC="/storage_containers/"
RESOURCE_IM="/images/"
RESOURCE_TK="/tasks/"

#keys
KEY_METADATA="metadata"
KEY_COUNT="count"
KEY_TOTAL_ENTITIES="total_entities"
KEY_ENTITY_ARRAY="entities"
KEY_VMDISK_UUID="vm_disk_id"
KEY_VM_UUID="uuid"
KEY_VMDISK_INFO="vm_disk_info"
KEY_DISK_ADDR="disk_address"
KEY_STORAGE_CONTAINER_UUID="storage_container_uuid"
KEY_NAME="name"
KEY_DESCRIPTION="description"
KEY_MEMORY="memory_mb"
KEY_NUM_VCPU_CORES="num_cores_per_vcpu"
KEY_NUM_VCPUS="num_vcpus"
KEY_POWER_STATE="power_state"
KEY_TASK_STATUS="progress_status"
KEY_TASK_UUID="task_uuid"


