#!/usr/bin/env bash

function config_ovs() {
    # Install ovs
    sudo apt update
    sudo apt install -y openvswitch-switch

    # Start and enable on reboots
    sudo systemctl start openvswitch-switch
    sudo systemctl enable openvswitch-switch
}

function update_netplan() {
    config_file="/etc/netplan/50-cloud-init.yaml"
    dns1=8.8.8.8
    dns2=8.8.4.4

    # Get machine MAC Address
    mac_address=$(ip link show | awk '/ether/ {print $2}' | head -n 1)

    # Backup the config file
    sudo cp "$config_file" "$config_file.bak"

    # Update the config file
    netplan_config=$(cat <<'EOF'
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      match:
        macaddress: $mac_address
      set-name: eth0
      nameservers:
          addresses: [$dns1, $dns2]
EOF
    )
    sudo bash -c "echo '$netplan_config'" > "$config_file"

    # Set the correct permission
    sudo chmod 600 "$config_file"

    # Apply the config
    sudo netplan apply
}

function main() {
    config_ovs
    if [ $? -eq 0 ]; then
        update_netplan
        if [ $? -eq 0 ]; then
            echo "Successfully chnaged your DNS!"
        else
            echo "There was a poblem while updating netplan config! Try restoring the backup on $config_file.bak"
        fi
    else
        echo "Aborting... (ovs installation failed!)"
    fi
}

main
