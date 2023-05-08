#!/bin/bash

# Container-Einstellungen
container_name="mein-container"
vmid=100
memory=512
disk_size=10G
ssh_port=2222

# SSH-Konfiguration
ssh_config="/etc/ssh/sshd_config"
ssh_port_config="Port $ssh_port"
permit_root_login_config="PermitRootLogin yes"
strict_modes_config="StrictModes yes"
ssh_service="/etc/init.d/ssh"

# Container erstellen
pct create $vmid -ostemplate local:vztmpl/debian-10-standard_10.5-1_amd64.tar.gz -storage local-lvm -hostname $container_name -memory $memory -net0 name=eth0,bridge=vmbr0,ip=dhcp
pct start $vmid

# SSH-Konfiguration anpassen
pct exec $vmid sed -i "s/#Port 22/$ssh_port_config/" $ssh_config
pct exec $vmid sed -i "s/#PermitRootLogin.*/$permit_root_login_config/" $ssh_config
pct exec $vmid sed -i "s/#StrictModes.*/$strict_modes_config/" $ssh_config
pct exec $vmid $ssh_service restart
pct exec $vmid systemctl enable ssh

echo "Container wurde erstellt und SSH-Konfiguration wurde angepasst."
