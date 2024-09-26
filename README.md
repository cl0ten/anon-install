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
    Ethereum Wallet Address (optional)

## Ethereum Wallet Configuration
During the process, you will be asked if you want to provide an Ethereum EVM address for receiving contribution rewards. This is optional and can be skipped.

## Backup and Customization
The script automatically backs up the original configuration file (/etc/anon/anonrc) before writing new settings. 

If needed, you can manually edit the configuration file after the installation or run the script again to backup the last settings to provide new ones.

## Example
Here's an example of the output from running the script:

```bash
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/cl0ten/anon-install/refs/heads/main/install.sh)"
```
```mathematics
..
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
==================================================

1/4 Enter the desired Nickname and Contact information for your Anon Relay
1/4 Nickname (1-19 characters, only [a-zA-Z0-9] and no spaces): nickname
1/4 Contact Information (leave empty to skip): noname@example.com

2/4 Enter a comma-separated list of fingerprints for your relay's family
2/4 MyFamily fingerprints (leave empty to skip): 6TE606BE5CB537A93E2CD0F2F5AJ0EA4C8B42FDB,0313A82A4CE6F9C4C1451099F91A1424BAC714M0

3/4 Enter BandwidthRate and BandwidthBurst in Mbit
Hint: BandwidthBurst must be at least equal to BandwidthRate
3/4 BandwidthRate (leave empty to skip): 80
3/4 BandwidthBurst (leave empty to skip): 100

4/4 Enter ORPort
[Default: 9001]: 9004

==================================================
    Ethereum Wallet Configuration (Optional)
==================================================

Optional: Do you want to enter an Ethereum EVM address for contribution rewards
(yes/no): yes
Enter your Ethereum wallet address: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
==================================================
             Configuration Summary
==================================================
Nickname nickname
ContactInfo noname@example.com @anon: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
Log notice file /var/log/anon/notices.log
ORPort 9004
#ControlPort 9051 # uncomment this line and restart the anon.service to enable the ControlPort
SocksPort 0
ExitRelay 0
IPv6Exit 0
ExitPolicy reject *:*
ExitPolicy reject6 *:*
BandwidthRate 80 Mbit
BandwidthBurst 100 Mbit
MyFamily 6TE606BE5CB537A93E2CD0F2F5AJ0EA4C8B42FDB,0313A82A4CE6F9C4C1451099F91A1424BAC714M0

==================================================
               Congratulations!
   Anon configuration completed successfully.
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
