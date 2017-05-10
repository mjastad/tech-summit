#!/bin/bash
source config.sh

##########################################################################################
# Function: quiesce
# Description: temporarily pauses system processing
#
# Inputs: param($1) Time (in seconds) to pause
#
##########################################################################################
quiesce() {
  echo "waiting for system to stablize..."
  sleep $1 
  echo
}

##########################################################################################
# Function: taskStatus 
# Description: temporarily blocks while checking task status.  When the task status 
#              reaches the condition set by param($2), the function unblocks, and resumes 
#              processing. 
#
# Inputs: param($1): task id json 
#         param($2): status to check for 
#
# Return: Task status (succeeded, failed) detected by system
##########################################################################################
taskStatus() {
 
   TASK_ID=$(echo $1 | jq -r ".${KEY_TASK_UUID}")  

   JSON=$(getResource $RESOURCE_TK$TASK_ID)
   TASK_STATUS=$(echo $JSON | jq -r ".${KEY_TASK_STATUS}")

   while [ $TASK_STATUS ==  $2 ]; do
       JSON=$(getResource $RESOURCE_TK$TASK_ID)
       TASK_STATUS=$(echo $JSON | jq -r ".${KEY_TASK_STATUS}")
       sleep 1
   done

   echo $TASK_STATUS
         
}

##########################################################################################
# Function: getResourceEntityProperty
# Description: Calls function::getResource{$1} and determines the number entities/resurce.  
#              Iterates through the entity[] array for the number of entities while 
#              comparing the value for a given key{$2} with a given value{$}.  If the value 
#              is found, the function returns a value for an lternate key{$4} 
#
# Inputs: param{$1}: resource (i.e. /vms/, /images/, etc...)
#         param{$2}: key to compare its associated value
#         param{$3}: value to compare the value from key{$2}
#         param{$4}: key to return the value
#
# return: json body for specified resource
##########################################################################################
getResourceEntityValue() {
  RET=" value not found..."
  JSON=$(getResource $1)
  TOTAL=$(echo $JSON | jq -r ".${KEY_METADATA}.${KEY_TOTAL_ENTITIES}")

  for ((i=0; i < $TOTAL; i++))
  do
    VAL=$(echo $JSON | jq -r ".${KEY_ENTITY_ARRAY}[${i}].${2}")
    if [[ $VAL == *"${3}"* ]]
     then
        RET=$(echo $JSON | jq -r ".${KEY_ENTITY_ARRAY}[${i}].${4}")
        break
    fi
  done
  echo $RET
}

##########################################################################################
# Function: getResource
# Description: Issues HTTP "GET /resource/" using curl and returns raw json for a i
#              specified resource:{$1}.
#
# Inputs: param{$1}: resource (i.e. /vms/, /images/, etc...)
#
# return: raw json body for a specified resource
##########################################################################################
getResource() {
  VALUE=$(curl --insecure -s -H $CT -X GET -u $USER:$PASSWD "$SERVICE_URL$1")
  echo $VALUE
}

##########################################################################################
# Function: getResourceValue
# Description: Issues HTTP "GET /resource/" using curl and returns a value for a given  
#              key:{$2}
#
# Inputs: param{$1}: resource (i.e. /vms/, /images/, etc...)
#         param{$2}: key (i.e. name, uuid, etc...)
#
# return: $VALUE representing a value for a spcified key given a resource name
##########################################################################################
getResourceValue() {
  JSON=$(getResource $1)
  VALUE=$(echo $JSON | jq -r $2)
  echo $VALUE
}

##########################################################################################
# Function: getResourceValues
# Description: Calls function::getResource{$1} and determines the number entities/resource
#              instance. Iterates through the number of entities in the entity[] array, 
#              capturing values for a given key{$2} and concatenating them to a string
#              delimited with ";".
#
# Inputs: param{$1}: resource (i.e. /vms/, /images/, etc...)
#         param{$2}: key for associated value
#
# return: A an array [] of values, where each value represents a resource instance, for a
#         given key.
##########################################################################################
getResourceValues() {
  ARRAY=()
  JSON=$(getResource $1)
  TOTAL=$(echo $JSON | jq -r ".${KEY_METADATA}.${KEY_TOTAL_ENTITIES}")

  for ((i=0; i < $TOTAL; i++))
  do
    VAL=$(echo $JSON | jq -r ".${KEY_ENTITY_ARRAY}[${i}].${2}")
    ARRAY+=("$VAL;") 
  done
  echo "${ARRAY[@]}"
}

##########################################################################################
# Function: createResource
# Description: creates a resource{$1} instance. 
#
# Inputs: param{$1}: resource (i.e. /vms/, /images/, etc...)
#         param{$@}: func name and params needed to create & return the JSON message-body. 
#
# return: response-body containing a uuid of the create process for task-management.
#
##########################################################################################
createResource() {
  VALUE=$(curl --insecure -s -H $ACCEPT -H $CT -X POST -u $USER:$PASSWD \
                                                     --data "$(${@:2})" "$SERVICE_URL$1")
  echo $VALUE
}


##########################################################################################
# Function: deleteResource
# Description: Deletes a resource{$1} instance referenced by the uuid param{$2} 
#
# Inputs: param{$1}: resource (i.e. /vms/, /images/, etc...)
#         param{$2}: uuid value representing resource instance to be deleted
#
# return: response-body containing uuid of the delete process for task-management. 
#         
##########################################################################################
deleteResource() {
  VALUE=$(curl --insecure -s -H $ACCEPT -H $CT -X DELETE -u $USER:$PASSWD "$SERVICE_URL$1$2")
  echo $VALUE
}

##########################################################################################
# Function: setPowerState 
# Description: powers a resource instance{$1} ON/OFF, referenced by the uuid param{$2}     
#
# Inputs: param{$1}: resource (i.e. /vms/, /images/, etc...)
#         param{$2}: uuid value representing resource instance to be deleted
#         param{$3}: power state ON/OFF 
#
# return: response-body containing uuid for task management 
#         
##########################################################################################
setPowerState() {
  VALUE=$(curl --insecure -s -H $ACCEPT -H $CT -X POST -u $USER:$PASSWD \
                               --data "$(${@:2})" "$SERVICE_URL$1$3$RESOURCE_VM_PWR_STATE")
  echo $VALUE
}

##########################################################################################
# Function: _GEN_VMPOST_MSG
# Description: creates and returns a JSON message-body for VM creation
#
# Inputs: param{$1}: vmdisk_uuid for windows image
#         param{$2}: storage_container_uuid for default-container
#         param{$3}: vmdisk_uuid for Nutanix Virt-IO image
#         param{$4}: vmdisk size in bytes 
#
# return: JSON
#
##########################################################################################
GEN_VM_CREATE_MSG() {

JSON='{ 
   	"description":"Tech Summit 2017", 
   	"guest_os":"Windows Server 2012 R2", 
   	"memory_mb":4096, 
   	"name":"W2K12R2", 
   	"num_cores_per_vcpu":1, 
   	"num_vcpus":1, 
   	"vm_disks":[ 
     	{ 
            "disk_address":{ 
               "device_bus":"ide", 
               "device_index":0 
            }, 
            "is_cdrom":true, 
            "is_empty":false, 
            "vm_disk_clone":{ 
               "disk_address":{ 
                  "vmdisk_uuid":"'"$1"'" 
                } 
            } 
        }, 
        {  
            "disk_address":{ 
               "device_bus":"scsi", 
               "device_index":0 
            }, 
            "vm_disk_create":{ 
               "storage_container_uuid":"'"$2"'", 
               "size":"'"$4"'" 
            } 
        }, 
        {  
            "disk_address":{ 
               "device_bus":"ide", 
               "device_index":1 
             }, 
             "is_cdrom":true, 
             "is_empty":false, 
             "vm_disk_clone":{ 
                "disk_address":{ 
                  "vmdisk_uuid":"'"$3"'" 
                } 
             } 
         } 
     ], 
     "hypervisor_type":"ACROPOLIS", 
     "affinity":null 
   }' 

   echo $JSON
}

##########################################################################################
# Function: GEN_VM_POWER_MSG
# Description: creates and returns a JSON message-body for VM Power State Transition 
#
# Inputs: param{$1}: uuid of VM 
#         param{$2}: power state ON/OFF 
#
# return: JSON
#
##########################################################################################
GEN_VM_POWER_MSG() {

JSON='{
        "transition": "'"$2"'",
        "uuid": "'"$1"'"
   }'

   echo $JSON
}


#eof
