# Anon Installation Script

## Description
This repository contains an updated script for installing and configuring the Anon Relay on Debian-based Linux systems. The script automates the process of adding the Anon repository, installing the Anon package, and configuring the Anon Relay with user-defined settings, including optional Ethereum wallet configuration for contribution rewards.

## Installation
To install the Anon Relay, run the following command in your terminal:
```bash
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/cl0ten/anon-install/refs/heads/main/install.sh)"
```
This will download and execute the latest version of the installation script. 

## Usage
The installation script will guide you through a step-by-step configuration process, allowing you to specify:

    Nickname for your Anon Relay
    Contact Information
    MyFamily fingerprints (optional)
    BandwidthRate and BandwidthBurst (optional)
    ORPort (with a default of 9001)
    ControlPort (optional, with a default of 9051)
    Ethereum Wallet Address (optional)
    Firewall Setup (optional)

## Ethereum Wallet Configuration
During the process, you will be asked if you want to provide an Ethereum EVM address for receiving contribution rewards. This is optional and can be skipped.
If you want to read more about the Rewards Program, visit [https://docs.anyone.io](https://docs.anyone.io).

## Backup and Customization
The script automatically backs up the original configuration file to /etc/anon/anonrc.bak before writing new settings.
If needed, you can manually edit the configuration file after the installation or run the script again to back up the last settings and provide new ones.

## Firewall Setup
The script offers an optional installation of the Uncomplicated Firewall (UFW) to secure the OS your Anon relay is running on by allowing traffic only through the specified ORPort and SSH port.
If you choose to use UFW, the script will:

    Install UFW (if not already installed)
    Allow traffic on the specified ORPort and SSH port
    Enable UFW

## Example
Here's an example of the output from running the script:

```bash
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/cl0ten/anon-install/refs/heads/main/install.sh)"
```
```mathematics
...
==================================================
           ANON Installation Complete
==================================================


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


==================================================
        Start Relay Configuration Wizard
  (Or abort and manually edit /etc/anon/anonrc)
==================================================

- Enter the desired Nickname and Contact information for your Anon Relay
1/7 Nickname (1-19 characters, only [a-zA-Z0-9] and no spaces): nickname
1/7 Contact Information (leave empty to skip): noname@example.com

- Enter a comma-separated list of fingerprints for your relay's family
2/7 MyFamily fingerprints (leave empty to skip): AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB,CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

- Enter BandwidthRate and BandwidthBurst in Mbit

Hint: BandwidthBurst must be at least equal to BandwidthRate.
3/7 BandwidthRate (leave empty to skip): 80
3/7 BandwidthBurst (leave empty to skip): 100

- Enter ORPort
4/7 ORPort [Default: 9001]: 9004

- Should the ControlPort be enabled?
5/7 [Default: yes]: yes

==================================================
    Ethereum Wallet Configuration (Optional)
==================================================

- Optional: Do you want to enter an Ethereum EVM address for contribution rewards
6/7 (yes/no): yes
6/7 Enter your Ethereum wallet address: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

==================================================
  Uncomplicated Firewall Installation (Optional)
==================================================

- Optional: Would you like to install UFW and allow traffic on ORPort 9004 and SSH port 22?
7/7 (yes/no): yes
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
ufw is already the newest version (0.36.1-4ubuntu0.1).
0 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
Rule added
Rule added (v6)
Skipping adding existing rule
Skipping adding existing rule (v6)
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup

==================================================
UFW installed and rules added for ORPort 9004 and SSH port 22.

Make sure old firewall rules are removed if they are no longer valid.
To show current UFW configuration: sudo ufw status
To remove an old rule: sudo ufw delete allow <port-number>
==================================================
For improved security, consider setting up SSH key authentication instead of using a password.
Refer to official documentation: https://www.ssh.com/ssh/keygen for instructions.

==================================================
               Congratulations!
   Anon configuration completed successfully.
==================================================

Nickname nickname
ContactInfo noname@example.com @anon: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
Log notice file /var/log/anon/notices.log
ORPort 9004
ControlPort 9051
SocksPort 0
ExitRelay 0
IPv6Exit 0
ExitPolicy reject *:*
ExitPolicy reject6 *:*
BandwidthRate 80 Mbit
BandwidthBurst 100 Mbit
MyFamily AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB,CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

==================================================
              https://docs.anyone.io
==================================================

```

## Dependencies
* curl
* sudo
* wget
* apt-get

## Contributing
Contributions to this script are welcome! If you'd like to contribute, please fork the repository, make your changes, and submit a pull request.

## License
This script is licensed under the GPL-3.0 licence.

## Contact
For questions or feedback, please contact the Anyone Development team at team@anyone.io

## External Resources
[Anyone Website](https://anyone.io)<br>
[Anon Education and Documentation](https://docs.anyone.io)<br>
[ANyONe Protocol/anyone-protocol GitHub](https://github.com/anyone-protocol)
