#!/bin/bash

set -euo pipefail

# SET COLOR VARIABLES

green=$(tput setaf 118)     # GREEN
yellow=$(tput setaf 3)      # YELLOW
reset=$(tput sgr0)          # RESET

# REUSABLE Banner

function Banner {
echo "

 ░░░░░░ ░░   ░░  ░░░░░      ░░░░░░░░  ░░░░░░   ░░░░░░  ░░      
▒▒      ▒▒  ▒▒  ▒▒   ▒▒        ▒▒    ▒▒    ▒▒ ▒▒    ▒▒ ▒▒      
▒▒      ▒▒▒▒▒   ▒▒▒▒▒▒▒        ▒▒    ▒▒    ▒▒ ▒▒    ▒▒ ▒▒      
▓▓      ▓▓  ▓▓  ▓▓   ▓▓        ▓▓    ▓▓    ▓▓ ▓▓    ▓▓ ▓▓      
 ██████ ██   ██ ██   ██        ██     ██████   ██████  ███████ 
                                      ${yellow}ᴮʸ ᴶᴼˢᴴᵁᴬ ᴹᴵᴸᴸᴱᵀᵀ${reset}"
}

function Master_Node_Setup {
read -p "Enter Master Username: " master_username
read -p "Enter Master Hostname: " master_hostname
read -sp "Enter Master Password: " master_password
clear

ssh ${master_username}@${master_hostname} "echo ${master_password} | ${RESET_MASTER} && '( kubeadm token create --print-join-command )' > /tmp/join_command"
sleep 40
}

function Worker_Node_Setup {
JOIN_COMMAND=$(cat /tmp/join_command)
read -p "Enter Worker Node Username: " worker_username
read -p "Enter Worker Node Hostname: " worker_hostname
read -sp "Enter Worker Node Password: " worker_password
clear

ssh ${worker_username}@${worker_hostname} "echo ${worker_password} | ${RESET_WORKER}"
sleep 2
clear
}

function Install_Menu {
declare GITLAB_BASE_URL="https://raw.githubusercontent.com"
declare GITLAB_REPO="joshkor1982/cka-study-tool/main"
declare RESET_WORKER="bash <(curl -s "${GITLAB_BASE_URL}"/"${GITLAB_REPO}"/install-k8s-worker.sh)"
declare RESET_MASTER="bash <(curl -s "${GITLAB_BASE_URL}"/"${GITLAB_REPO}"/install-k8s-master.sh)"
declare RESET_MASTER="bash <(curl -s "${GITLAB_BASE_URL}"/"${GITLAB_REPO}"/install-k8s-master.sh)"d
Banner && echo "🌌  INSTALL MENU  🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  SET UP MASTER NODE
🔱 2  SET UP WORKER NODE
🔱 3  GET JOIN COMMAND
🔱 4  UPGRADE A KUBERNETES CLUSTER
🔱 0  RETURN TO MAIN MENU -->
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in  
  "1")  reset && Master_Node_Setup;;
  "2")  reset && Worker_Node_Setup && reset && Install_Menu;;
  "3")  reset && UPGRADE_MENU;;
  "4")  reset && ETCD_BACKUP_RESTORE_MENU;;
  "0")  reset && Main_Menu;;  
  *)    INVALID_SELECTION;;
esac
}

function Role_Function {
read -r -p "Enter ${green}${rbac_options[$selection]}${reset} name: (pod-reader) " role_name
file_name="${rbac_options[$selection]}-example.yaml"
[[ -f "${file_name}" ]] && rm -rf $file_name &&
[[ -f "${file_name}" ]] ||
  { kubectl create role ${role_name} \
    --verb=get,list,watch \
    --resource=pods \
    --dry-run=client -o yaml > ${file_name}
  }

echo "${green}${rbac_options[$selection]}${reset} example manifest:"
grep --color -E "${role_name}|$" "${file_name}"
read -r -p "Press Enter to return to RBAC menu: "
reset && Rbac_Menu
}

function ClusterRole_Function {
read -r -p "Enter ${green}${rbac_options[$selection]}${reset} name: (pod-reader) " cluster_role_name
file_name="${rbac_options[$selection]}-example.yaml"
[[ -f "${file_name}" ]] && rm -rf $file_name &&
[[ -f "${file_name}" ]] ||
  { kubectl create clusterrole ${cluster_role_name} \
    --verb=get,list,watch \
    --resource=pods \
    --dry-run=client -o yaml > ${file_name}
  }

echo "${green}${rbac_options[$selection]}${reset} example manifest:"
grep --color -E "${cluster_role_name}|$" "${file_name}"
read -r -p "Press Enter to return to RBAC menu: "
reset && Rbac_Menu
}

function ClusterRoleBinding_Function {
read -r -p "Enter ${green}${rbac_options[$selection]}${reset} name: (cluster-admin) " cluster_role_binding_name
read -r -p "Enter ${green}ClusterRole${reset} name: (cluster-admin) " cluster_role_name
read -r -p "Enter ${green}Username${reset} to have ${cluster_role_binding_name} access: " user
read -r -p "Enter ${green}Group${reset} to have ${cluster_role_binding_name} access: " group

file_name="${rbac_options[$selection]}-example.yaml"
[[ -f "${file_name}" ]] && rm -rf $file_name &&
[[ -f "${file_name}" ]] ||
  { kubectl create clusterrolebinding "${cluster_role_binding_name}" \
    --clusterrole="${cluster_role_name}" \
    --user="${user}" \
    --group="${group}" \
    --dry-run=client -o yaml > ${file_name} 
  }

echo "${green}${rbac_options[$selection]}${reset} example manifest:"
grep --color -E "${cluster_role_binding_name}|${cluster_role_name}|${user}|${group}|$" "${file_name}"
echo "Press Enter to return to RBAC menu: "
reset && Rbac_Menu
}

function Rbac_Menu {

declare -a rbac_options
rbac_options=("Role" "ClusterRole" "ClusterRoleBinding")
rbac_array_length="$((${#rbac_options[@]}-1))"

Banner && echo "🌌  RBAC TOOL  🌌"
echo "
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 0  ROLE
🔱 1  CLUSTER ROLE
🔱 2  CLUSTER ROLE BINDING
🔱 3  COMMANDS
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select the type of RBAC resource to create: (0-${rbac_array_length}) " selection
[[ ("${selection}" -lt 0 || "${selection}" -ge "${#rbac_options[@]}") ]] \
    && { read -r -p "${yellow}Not a valid option. Press Enter to try again: ${reset}" 
    reset && Yaml_Creator_Menu
    } || "${rbac_options[$selection]}"_Function
}

function Menu_One {
Banner && echo "🌌  ARCHITECTURE, INSTALLATION, CONFIGURATION  🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  RBAC
🔱 2  CLUSTER INSTALLATION
🔱 3  ETCD BACKUP/RESTORE
🔱 4  MANAGE AN HA CLUSTER
🔱 0  RETURN TO MAIN MENU -->
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in  
  "1")  reset && Rbac_Menu;;
  "2")  reset && Install_Menu;;
  "3")  reset && ETCD_BACKUP_RESTORE_MENU;;
  "4")  reset && MANAGE_HA_CLUSTER_MENU;;
  "0")  reset && Main_Menu;;  
  *)    INVALID_SELECTION;;
esac
}

function Menu_Two {
Banner && echo "🌌  WORKLOADS AND SCHEDULING  🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  DEPLOYMENTS
🔱 2  ROLLING UPDATES AND ROLLBACKS
🔱 3  SECRETS AND CONFIGMAPS
🔱 4  SCALING
🔱 5  SELF-HEALING
🔱 6  RESOURCE LIMITS AND SCHEDULING
🔱 7  MANIFEST MANAGEMENT AND TEMPLATING
🔱 0  RETURN TO MAIN MENU -->
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in
  "1")  reset && DEPLOYMENT_MENU;;    
  "2")  reset && ROLLBACKS_UPDATES_MENU;;
  "3")  reset && SECRETS_AND_CONFIGMAPS_MENU;;
  "4")  reset && SCALING_MENU;;
  "5")  reset && SELF-HEALING_MENU;;
  "6")  reset && LIMITS_SCHEDULING_MENU;;
  "7")  reset && MANIFEST_TEMPLATING_MENU;;
  "0")  reset && Main_Menu;;
  *)    INVALID_SELECTION;;
esac
}

function Menu_Three {
Banner && echo "🌌  SERVICES AND NETWORKING  🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  HOST NETWORKING ON NODES
🔱 2  CLUSTER IP, NODEPORT, LOAD BALANCERS
🔱 3  SERVICE TYPES AND ENDPOINTS
🔱 4  INGRESS
🔱 5  COREDNS
🔱 6  CONTAINER NETWORK INTERFACES (CNI)
🔱 0  RETURN TO MAIN MENU <--
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in
  "1")  reset && HOST_NETWORKING_MENU;;    
  "2")  reset && CLUSTER_IP_MENU;;
  "3")  reset && SERVICES_MENU;;
  "4")  reset && INGRESS_MENU;;
  "5")  reset && COREDNS_MENU;;
  "6")  reset && CNI_MENU;;
  "0")  reset && Main_Menu;;
  *)    INVALID_SELECTION;;
esac
}

function Menu_Four {
Banner && echo "🌌  STORAGE  🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  STORAGE CLASSES
🔱 2  VOLUME & ACCESS MODES
🔱 3  RECLAIM POLICIES
🔱 4  PERSISTENT VOLUMES/CLAIMS
🔱 0  RETURN TO MAIN MENU <--
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in   
  "1")  reset && STORAGE_CLASS_MENU;;
  "2")  reset && MODES_MENU;;
  "3")  reset && RECLAIM_POLICY_MENU;;
  "4")  reset && PV_AND_PVC_MENU;;
  "0")  reset && Main_Menu;; 
  *)    INVALID_SELECTION;;
esac
}

function Menu_Five {
Banner && echo "🌌  TROUBLESHOOTING  🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  LOGGING
🔱 2  MONITORING
🔱 3  STDIN STDERR LOGS
🔱 4  APPLICATION FAILURE
🔱 5  COMPONENT FAILURE
🔱 6  NETWORKING FAILURE
🔱 0  RETURN TO MAIN MENU <--
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in   
  "1")  reset && LOGGING_MENU;;
  "2")  reset && STDIN_STDERR_MENU;;
  "3")  reset && APP_FAILURE_MENU;;
  "4")  reset && COMPONENT_FAILURE_MENU;;
  "4")  reset && NETWORKING_FAILURE_MENU;;
  "0")  reset && Main_Menu;; 
  *)    INVALID_SELECTION;;
esac
}

function Menu_Six {
Banner && echo "🌌  COMMAND QUICK REFERENCE 🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  SEARCH FOR COMMAND
🔱 2  BROWSE ALL COMMANDS
🔱 0  RETURN TO MAIN MENU <--
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in
  "1") reset && SEARCH_COMMAND;;
  "2") reset && BROWSE_COMMAND;;
  "0") reset && Main_Menu;;
  *)    INVALID_SELECTION;;
esac
}

# MAIN/START MENU

function Main_Menu {
Banner && echo "🌌  M A I N  M E N U 🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  ARCHITECTURE, INSTALLATION, CONFIGURATION (25%)
🔱 2  WORKLOADS AND SCHEDULING (15%)
🔱 3  SERVICES AND NETWORKING (20%)
🔱 4  STORAGE (10%)
🔱 5  TROUBLESHOOTING (30%)
🔱 6  SEARCH FOR A COMMAND
🔱 0  EXIT <--
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in
  "0")  reset && exit 1;;    
  "1")  reset && Menu_One;;
  "2")  reset && Menu_Two;;
  "3")  reset && Menu_Three;;
  "4")  clear && Menu_Four;;
  "5")  clear && Menu_Five;;
  "6")  clear && Menu_Six;;
  *)    INVALID_SELECTION;;
esac
}
reset && Main_Menu