#!/bin/bash

# TODO
#
# Validation for:
# ORPort (range of allowed ports)
# BandwidthRate  (only numbers in Mbit)
# BandwidthBurst (only numbers in Mbit)
# MyFamily FF (comma-separated upper case 40 char fingerprints)

#Decide if 5/7 Enable ControlPort? [Default: yes or no (?)

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BLUE_ANON='\033[38;2;2;128;175m'
NOCOLOR='\033[0m'

# load release info
. /etc/os-release

# check sudo
if ! command -v sudo &>/dev/null; then
    echo -e "${RED}Error: sudo command not found. Please make sure that you run the installation command with sudo.${NOCOLOR}"
    exit 1
fi

# install anon package
echo -e "${BLUE_ANON}==================================================${NOCOLOR}"
echo -e "${GREEN}           Starting ANON Installation             ${NOCOLOR}"
echo -e "${BLUE_ANON}==================================================${NOCOLOR}"

wget -qO- https://deb.en.anyone.tech/anon.asc | sudo tee /etc/apt/trusted.gpg.d/anon.asc
echo "deb [signed-by=/etc/apt/trusted.gpg.d/anon.asc] https://deb.en.anyone.tech anon-live-$VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/anon.list
sudo apt-get update --yes
#sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes anon
sudo apt-get install anon --yes

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install the anon package. Quitting installation. Ensure $PRETTY_NAME $VERSION_CODENAME is supported.${NOCOLOR}"
    exit 1
fi

echo -e "${BLUE_ANON}==================================================${NOCOLOR}"
echo -e "${GREEN}           ANON Installation Complete             ${NOCOLOR}"
echo -e "${BLUE_ANON}==================================================${NOCOLOR}"

# backup config file
sudo cp /etc/anon/anonrc /etc/anon/anonrc.bak

# print ascii
echo -e "${BLUE_ANON}"
cat << "EOF"

                                                                 /$$
                                                                |__/
  /$$$$$$  /$$$$$$$  /$$   /$$  /$$$$$$  /$$$$$$$   /$$$$$$      /$$  /$$$$$$
 |____  $$| $$__  $$| $$  | $$ /$$__  $$| $$__  $$ /$$__  $$    | $$ /$$__  $$
  /$$$$$$$| $$  \ $$| $$  | $$| $$  \ $$| $$  \ $$| $$$$$$$$    | $$| $$  \ $$
 /$$__  $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$_____/    | $$| $$  | $$
|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$/| $$  | $$|  $$$$$$$ /$$| $$|  $$$$$$/
 \_______/|__/  |__/ \____  $$ \______/ |__/  |__/ \_______/|__/|__/ \______/
                     /$$  | $$
                    |  $$$$$$/
                     \______/

EOF

# start config
echo -e "${BLUE_ANON}\n==================================================${NOCOLOR}"
echo -e "${GREEN}        Start Relay Configuration Wizard          ${NOCOLOR}"
echo -e "${CYAN}  (Or abort and manually edit /etc/anon/anonrc)   ${NOCOLOR}"
echo -e "${BLUE_ANON}==================================================${NOCOLOR}"

# nickname
echo -e "${CYAN}\n- Enter the desired Nickname and Contact information for your Anon Relay${NOCOLOR}"
read -p "1/7 Nickname (1-19 characters, only [a-zA-Z0-9] and no spaces): " NICKNAME
while ! [[ "$NICKNAME" =~ ^[a-zA-Z0-9]{1,19}$ ]]; do
    echo -e "${RED}Error: Invalid nickname format. Please enter 1-19 characters, only [a-zA-Z0-9] and no spaces.${NOCOLOR}"
    echo -e "1/7${CYAN}- Enter the desired Nickname and Contact information for your Anon Relay${NOCOLOR}"
	read -p "1/7 Nickname (1-19 characters, only [a-zA-Z0-9] and no spaces): " NICKNAME
done

# contactinfo
read -p "1/7 Contact Information (leave empty to skip): " CONTACT_INFO

# myfamily
echo -e "${CYAN}\n- Enter a comma-separated list of fingerprints for your relay's family${NOCOLOR}"
read -p "2/7 MyFamily fingerprints (leave empty to skip): " MY_FAMILY
while [[ -n "$MY_FAMILY" && ! "$MY_FAMILY" =~ ^([A-Z0-9]+,)*[A-Z0-9]+$ ]]; do
    echo -e "${RED}Error: Invalid MyFamily format. Please enter comma-separated fingerprints with only capital letters.${NOCOLOR}"
    echo -e "${CYAN}- Enter a comma-separated list of fingerprints for your relay's family${NOCOLOR}"
	read -p "2/7 MyFamily fingerprints (leave empty to skip): " MY_FAMILY
done

# bandwidthrate
echo -e "${CYAN}\n- Enter BandwidthRate and BandwidthBurst in Mbit ${NOCOLOR}"
#echo -e "Hint: ${BLUE_ANON}BandwidthBurst must be at least equal to BandwidthRate. ${NOCOLOR}"
read -p "3/7 BandwidthRate (leave empty to skip): " BANDWIDTH_RATE
read -p "3/7 BandwidthBurst (leave empty to skip): " BANDWIDTH_BURST

# ORport
while true; do
    echo -e "${CYAN}\n- Enter ORPort${NOCOLOR}"
    read -rp "4/7 ORPort [Default: 9001]: " OR_PORT
    OR_PORT="${OR_PORT:-9001}"
    if [[ $OR_PORT =~ ^[0-9]+$ ]]; then
        break
    else
        echo -e "${RED}Error: Invalid ORPort format. Must contain only numbers.${NOCOLOR}" >&2
    fi
done

# controlPort
while true; do
    echo -e "${CYAN}\n- Should the ControlPort be enabled?${NOCOLOR}"
    read -rp "5/7 Enable ControlPort? [Default: yes]: " ENABLE_CONTROL_PORT   #hmmmmmmmmmmmm, should this be default: yes or no????
    ENABLE_CONTROL_PORT="${ENABLE_CONTROL_PORT:-yes}"
    if [[ "$ENABLE_CONTROL_PORT" =~ ^[Yy][Ee][Ss]$ ]]; then
        CONTROL_PORT="9051"
        break
    elif [[ "$ENABLE_CONTROL_PORT" =~ ^[Nn][Oo]$ ]]; then
        CONTROL_PORT=""
        break
    else
        echo -e "${RED}Error: Please respond with 'yes' or 'no'.${NOCOLOR}"
    fi
done

# EVM address
echo -e "${BLUE_ANON}\n==================================================${NOCOLOR}"
echo -e "${CYAN}    Ethereum Wallet Configuration (Optional)      ${NOCOLOR}"
echo -e "${BLUE_ANON}==================================================${NOCOLOR}"

while true; do
    echo -e "${CYAN}\n- Do you want to enter an Ethereum EVM address for contribution rewards${NOCOLOR}"
    read -p "6/7 (yes/no): " HAS_ETH_WALLET
    case "$HAS_ETH_WALLET" in
        [Yy][Ee][Ss])
            while true; do
                read -p "6/7 Enter your Ethereum wallet address: " ETH_WALLET
                if [[ "$ETH_WALLET" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
                    CONTACT_INFO="$CONTACT_INFO @anon: $ETH_WALLET"
                    break
                else
                    echo -e "${RED}Error: Invalid Ethereum wallet address format. Must start with '0x' followed by 40 hexadecimal characters.${NOCOLOR}"
                fi
            done
            break
            ;;
        [Nn][Oo])
            break
            ;;
        *)
            echo -e "${RED}Error: Please respond with 'yes' or 'no'.${NOCOLOR}"
            ;;
    esac
done

echo -e "${BLUE_ANON}\n==================================================${NOCOLOR}"
echo -e "${CYAN}  Uncomplicated Firewall Installation (Optional)  ${NOCOLOR}"
echo -e "${BLUE_ANON}==================================================${NOCOLOR}"

# SSH port check
SSH_PORT=$(grep -E '^[^#]*Port ' /etc/ssh/sshd_config | awk '{print $2}' | head -n 1)
if [ -z "$SSH_PORT" ]; then
    SSH_PORT=22
fi

# ufw installation
while true; do
    echo -e "${CYAN}\n- Would you like to install UFW and allow traffic on ORPort ${NOCOLOR}$OR_PORT ${CYAN}and SSH port ${NOCOLOR}$SSH_PORT${CYAN}?${NOCOLOR}"
    read -rp "7/7 (yes/no): " INSTALL_UFW
    case "$INSTALL_UFW" in
        [Yy][Ee][Ss])
            sudo apt-get install ufw --yes
            sudo ufw allow "$OR_PORT"
            sudo ufw allow "$SSH_PORT"
            sudo ufw enable
			
			echo -e "${BLUE_ANON}\n==================================================${NOCOLOR}"
            echo -e "${GREEN}UFW installed and rules added for ORPort ${NOCOLOR}$OR_PORT ${GREEN}and SSH port ${NOCOLOR}$SSH_PORT${GREEN}.${NOCOLOR}"
			echo -e "${CYAN}\nMake sure old firewall rules are removed if they are no longer valid.${NOCOLOR}"
			echo -e "${CYAN}To show current UFW configuration:${NOCOLOR} ${GREEN}sudo ufw status${NOCOLOR}"
			echo -e "${CYAN}To remove an old rule:${NOCOLOR} ${GREEN}sudo ufw delete allow <port-number>${NOCOLOR}"
			#echo -e "${BLUE_ANON}==================================================${NOCOLOR}"
            break
            ;;
        [Nn][Oo])
			echo -e "${BLUE_ANON}\n==================================================${NOCOLOR}"
            echo -e "${GREEN}Skipping UFW installation.${NOCOLOR}"
			#echo -e "${BLUE_ANON}==================================================${NOCOLOR}"
            break
            ;;
        *)
            echo -e "${RED}Error: Please respond with 'yes' or 'no'.${NOCOLOR}"
            ;;
    esac
done

# SSH keys setup reminder
echo -e "${CYAN}\nFor improved security, consider setting up SSH key authentication.${NOCOLOR}"
echo -e "${CYAN}Refer to official documentation: https://www.ssh.com/ssh/keygen for instructions.${NOCOLOR}\n"

# write config to anonrc
sudo rm -f /etc/anon/anonrc

cat <<EOF | sudo tee /etc/anon/anonrc >/dev/null
Nickname $NICKNAME
ContactInfo $CONTACT_INFO
Log notice file /var/log/anon/notices.log
ORPort $OR_PORT
ControlPort ${CONTROL_PORT:-0}
SocksPort 0
ExitRelay 0
IPv6Exit 0
ExitPolicy reject *:*
ExitPolicy reject6 *:*
$( [[ -n "$BANDWIDTH_RATE" ]] && echo "BandwidthRate $BANDWIDTH_RATE Mbit" )
$( [[ -n "$BANDWIDTH_BURST" ]] && echo "BandwidthBurst $BANDWIDTH_BURST Mbit" )
EOF

if [[ -n "$MY_FAMILY" ]]; then
    echo "MyFamily $MY_FAMILY" | sudo tee -a /etc/anon/anonrc >/dev/null
fi

# show fingerprint
FINGERPRINT_FILE="/var/lib/anon/fingerprint"

function show_fingerprint {
    if [ -f "$FINGERPRINT_FILE" ]; then
        echo -e "${BLUE_ANON}==================================================${NOCOLOR}"
        echo -e "${GREEN}            Anon Relay Fingerprint:                ${NOCOLOR}"
        cat "$FINGERPRINT_FILE"
        echo -e "${BLUE_ANON}==================================================${NOCOLOR}\n"
    else
        echo -e "${RED}Error: Fingerprint file not found at $FINGERPRINT_FILE.${NOCOLOR}"
        echo "Please make sure the service is properly configured and running."
    fi
}

# restart service
sudo systemctl restart anon.service

# check if the fingerprint file is generated
if [ ! -f "$FINGERPRINT_FILE" ]; then
    echo -e "${CYAN}Waiting for the fingerprint to be generated...${NOCOLOR}\n"
    while [ ! -f "$FINGERPRINT_FILE" ]; do
        sleep 2
    done
fi

# display the fingerprint
show_fingerprint

# show config
cat /etc/anon/anonrc

echo -e "${GREEN}\n==================================================${NOCOLOR}"
echo -e "${BLUE_ANON}               Congratulations!                   ${NOCOLOR}"
echo -e "${GREEN}   Anon configuration completed successfully.     ${NOCOLOR}"
echo -e "${BLUE_ANON}            https://docs.anyone.io              ${NOCOLOR}"
echo -e "${GREEN}==================================================${NOCOLOR}"
