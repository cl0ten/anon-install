#!/bin/bash

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NOCOLOR='\033[0m'

# load release info
. /etc/os-release

# check sudo
if ! command -v sudo &>/dev/null; then
    echo -e "${RED}Error: sudo command not found. Please make sure that you run the installation command with sudo bin/bash ..${NOCOLOR}"
    exit 1
fi


# install anon package
echo -e "${CYAN}==================================================${NOCOLOR}"
echo -e "${CYAN}          Starting ANON Installation              ${NOCOLOR}"
echo -e "${CYAN}==================================================${NOCOLOR}"

sudo wget -qO- https://deb.en.anyone.tech/anon.asc | sudo tee /etc/apt/trusted.gpg.d/anon.asc
sudo echo "deb [signed-by=/etc/apt/trusted.gpg.d/anon.asc] https://deb.en.anyone.tech anon-live-$VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/anon.list
sudo apt-get update --yes
sudo apt-get install anon --yes

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install the anon package. Quitting installation. Ensure $PRETTY_NAME $VERSION_CODENAME is supported.${NOCOLOR}"
    exit 1
fi

echo -e "${CYAN}==================================================${NOCOLOR}"
echo -e "${CYAN}          Installation Complete                   ${NOCOLOR}"
echo -e "${CYAN}==================================================${NOCOLOR}"


sudo cp /etc/anon/anonrc /etc/anon/anonrc.bak

# print ascii
echo -e "${BLUE}"
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
echo -e "${NOCOLOR}"

# start config
echo -e "${CYAN}==================================================${NOCOLOR}"
echo -e "${CYAN}       Start Relay Configuration Wizard           ${NOCOLOR}"
echo -e "${CYAN}==================================================${NOCOLOR}"


# nickname
echo -e "${NOCOLOR}"
echo -e "Enter the desired nickname for your Anon Relay"
read -p "(1-19 characters, only [a-zA-Z0-9] and no spaces): " NICKNAME
while ! [[ "$NICKNAME" =~ ^[a-zA-Z0-9]{1,19}$ ]]; do
    echo -e "${RED}Error: Invalid nickname format. Please enter 1-19 characters, only [a-zA-Z0-9] and no spaces.${NOCOLOR}"
    read -p "Enter the desired nickname for your Anon Relay (1-19 characters, only [a-zA-Z0-9] and no spaces): " NICKNAME
done

# contactinfo
echo -e "${NOCOLOR}"
read -p "Enter your contact information for the Anon Relay: " CONTACT_INFO

# myfamily
echo -e "${NOCOLOR}"
echo "Enter a comma-separated list of fingerprints for your relay's family "
read -p "(leave empty to skip): " MY_FAMILY
while [[ -n "$MY_FAMILY" && ! "$MY_FAMILY" =~ ^([A-Z0-9]+,)*[A-Z0-9]+$ ]]; do
    echo -e "${RED}Error: Invalid MyFamily format. Please enter comma-separated fingerprints with only capital letters.${NOCOLOR}"
    read -p "Enter a comma-separated list of fingerprints for your relay's family (leave empty to skip): " MY_FAMILY
done

# bandwidthrate
echo -e "${NOCOLOR}"
echo "Enter BandwidthRate in Mbit "
read -p "(leave empty to skip): " BANDWIDTH_RATE
echo -e "${NOCOLOR}"
echo "Enter BandwidthBurst in Mbit "
read -p "(leave empty to skip): " BANDWIDTH_BURST

# ORport
while true; do
    echo -e "${NOCOLOR}"
    echo "Enter ORPort"
    read -rp "[Default: 9001]: " OR_PORT
    OR_PORT="${OR_PORT:-9001}"
    if [[ $OR_PORT =~ ^[0-9]+$ ]]; then
        break
    else
        echo -e "${RED}Error: Invalid ORPort format. Must contain only numbers.${NOCOLOR}" >&2
    fi
done

# EVM address
echo -e "${NOCOLOR}"
echo -e "${CYAN}==================================================${NOCOLOR}"
echo -e "${CYAN}     Ethereum Wallet Configuration (Optional)     ${NOCOLOR}"
echo -e "${CYAN}==================================================${NOCOLOR}"

while true; do
    echo -e "${NOCOLOR}"
    echo "Do you want to enter your Ethereum address for contribution rewards before finishing the configuration?"
    read -p "(yes/no): " HAS_ETH_WALLET
    case "$HAS_ETH_WALLET" in
        [Yy][Ee][Ss])
            while true; do
                read -p "Enter your Ethereum wallet address: " ETH_WALLET
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

# write configuration to anonrc
sudo rm -f /etc/anon/anonrc

cat <<EOF | sudo tee /etc/anon/anonrc >/dev/null
Nickname $NICKNAME
ContactInfo $CONTACT_INFO
Log notice file /var/log/anon/notices.log
ORPort $OR_PORT
ControlPort 9051
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

# restart the service
sudo systemctl restart anon.service

# show config
echo -e "${GREEN}==================================================${NOCOLOR}"
echo -e "${GREEN}              Configuration Summary               ${NOCOLOR}"
echo -e "${GREEN}==================================================${NOCOLOR}"
cat /etc/anon/anonrc
echo -e "${NOCOLOR}"
echo -e "${GREEN}==================================================${NOCOLOR}"
echo -e "${GREEN}   Anon configuration completed successfully.     ${NOCOLOR}"
echo -e "${GREEN}==================================================${NOCOLOR}"
