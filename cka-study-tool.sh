#!/bin/bash
set -euo pipefail

GR=$(tput setaf 118) # GREEN
YL=$(tput setaf 3)   # YELLOW
RS=$(tput sgr0)      # RESET COLOR

BANNER () {
echo "

 ░░░░░░ ░░   ░░  ░░░░░      ░░░░░░░░  ░░░░░░   ░░░░░░  ░░      
▒▒      ▒▒  ▒▒  ▒▒   ▒▒        ▒▒    ▒▒    ▒▒ ▒▒    ▒▒ ▒▒      
▒▒      ▒▒▒▒▒   ▒▒▒▒▒▒▒        ▒▒    ▒▒    ▒▒ ▒▒    ▒▒ ▒▒      
▓▓      ▓▓  ▓▓  ▓▓   ▓▓        ▓▓    ▓▓    ▓▓ ▓▓    ▓▓ ▓▓      
 ██████ ██   ██ ██   ██        ██     ██████   ██████  ███████ 
                                      ${YL}ᴮʸ ᴶᴼˢᴴᵁᴬ ᴹᴵᴸᴸᴱᵀᵀ${RS}"
}

INVALID_SELECTION () {
  echo "INVALID SELECTION. PRESS ENTER TO TRY AGAIN: "
  read -r
}

SEARCH_COMMAND () {
  read -r -p "ENTER KEYWORD TO SEARCH FOR: " command
  search_command="$(cat command_list.txt | grep -i ${command})"
 
  if [[ ${search_command} ]]; then
    cat ./command_list.txt | grep -iw --color "${command}" | less
    read -r -p "WOULD YOU LIKE TO SEARCH AGAIN? (Y|N): " yn
    case "${yn}" in
      [yY]*) reset && SEARCH_COMMAND;;
      [nN]*) reset && MENU_SIX;;
      *)  INVALID_SELECTION;;
    esac
  else
    read -r -p "COMMAND NOT FOUND, WOULD YOU LIKE TO SEARCH AGAIN? (Y|N):  " yn 
    case "${yn}" in
      [yY]*) reset && SEARCH_COMMAND;;
      [nN]*) reset && MENU_SIX;;
      *)  INVALID_SELECTION;;
    esac
  fi
}

BROWSE_COMMAND () {
  cat ./command_list.txt | less
  read -r -p "WOULD YOU LIKE TO BROWSE AGAIN? (Y|N): " YN
  case "${YN}" in
    [yY]*) reset && BROWSE_COMMAND;;
    [nN]*) reset && MENU_SIX;;
    *)  INVALID_SELECTION;;
  esac
}

MENU_ONE () {
BANNER && echo "🌌  ARCHITECTURE, INSTALLATION, CONFIGURATION  🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  RBAC
🔱 2  CLUSTER INSTALLATION
🔱 3  UPGRADE A CLUSTER
🔱 4  ETCD BACKUP/RESTORE
🔱 5  MANAGE AN HA CLUSTER
🔱 0  RETURN TO MAIN MENU -->
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in
  "0")  reset && MAIN_MENU;;    
  "1")  reset && RBAC_MENU;;
  "2")  reset && INSTALL_MENU;;
  "3")  reset && UPGRADE_MENU;;
  "4")  reset && ETCD_BACKUP_RESTORE_MENU;;
  "5")  reset && MANAGE_HA_CLUSTER_MENU;;
  *)    INVALID_SELECTION;;
esac

}
MENU_TWO () {
BANNER && echo "🌌  WORKLOADS AND SCHEDULING  🌌

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
  "0")  reset && MAIN_MENU;;
  "1")  reset && DEPLOYMENT_MENU;;    
  "2")  reset && ROLLBACKS_UPDATES_MENU;;
  "3")  reset && SECRETS_AND_CONFIGMAPS_MENU;;
  "4")  reset && SCALING_MENU;;
  "5")  reset && SELF-HEALING_MENU;;
  "6")  reset && LIMITS_SCHEDULING_MENU;;
  "7")  reset && MANIFEST_TEMPLATING_MENU;;
  *)    INVALID_SELECTION;;
esac
}

MENU_THREE () {
BANNER && echo "🌌  SERVICES AND NETWORKING  🌌

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
  "0")  reset && MAIN_MENU;;
  "1")  reset && HOST_NETWORKING_MENU;;    
  "2")  reset && CLUSTER_IP_MENU;;
  "3")  reset && SERVICES_MENU;;
  "4")  reset && INGRESS_MENU;;
  "5")  reset && COREDNS_MENU;;
  "6")  reset && CNI_MENU;;
  *)    INVALID_SELECTION;;
esac
}

MENU_FOUR () {
BANNER && echo "🌌  STORAGE  🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  STORAGE CLASSES
🔱 2  VOLUME & ACCESS MODES
🔱 3  RECLAIM POLICIES
🔱 4  PERSISTENT VOLUMES/CLAIMS
🔱 0  RETURN TO MAIN MENU <--
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in
  "0")  reset && MAIN_MENU;;    
  "1")  reset && STORAGE_CLASS_MENU;;
  "2")  reset && MODES_MENU;;
  "3")  reset && RECLAIM_POLICY_MENU;;
  "4")  reset && PV_AND_PVC_MENU;;
  *)    INVALID_SELECTION;;
esac
}

MENU_FIVE () {
BANNER && echo "🌌  TROUBLESHOOTING  🌌

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
  "0")  reset && MAIN_MENU;;    
  "1")  reset && LOGGING_MENU;;
  "2")  reset && STDIN_STDERR_MENU;;
  "3")  reset && APP_FAILURE_MENU;;
  "4")  reset && COMPONENT_FAILURE_MENU;;
  "4")  reset && NETWORKING_FAILURE_MENU;;
  *)    INVALID_SELECTION;;
esac
}

MENU_SIX () {
BANNER && echo "🌌  COMMAND QUICK REFERENCE 🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  SEARCH FOR COMMAND
🔱 2  BROWSE ALL COMMANDS
🔱 0  RETURN TO MAIN MENU <--
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in
  "0") reset && MAIN_MENU;;
  "1") reset && SEARCH_COMMAND;;
  "2") reset && BROWSE_COMMAND;;
  *)    INVALID_SELECTION;;
esac
}

MAIN_MENU () {
BANNER && echo "🌌  M A I N  M E N U 🌌

🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀
🔱 1  ARCHITECTURE, INSTALLATION, CONFIGURATION (25%)
🔱 2  WORKLOADS AND SCHEDULING (15%)
🔱 3  SERVICES AND NETWORKING (20%)
🔱 4  STORAGE (10%)
🔱 5  TROUBLESHOOTING (30%)
🔱 6  COMMAND CHEAT SHEET
🔱 0  EXIT <--
🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀🌀"
read -r -p "Select an Option: " option
case "${option}" in
  "0")  reset && exit 1;;    
  "1")  reset && MENU_ONE;;
  "2")  reset && MENU_TWO;;
  "3")  reset && MENU_THREE;;
  "4")  clear && MENU_FOUR;;
  "5")  clear && MENU_FIVE;;
  "6")  clear && MENU_SIX;;
  *)    INVALID_SELECTION;;
esac
}
reset && MAIN_MENU
