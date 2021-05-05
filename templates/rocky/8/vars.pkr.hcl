os_name = "rocky"
os_version = "8"
guest_type = "centos8_64Guest"
iso_name = "Rocky-8.3-x86_64-minimal.iso"
floppy_files = "ks.cfg"
provision_commands = "dnf install -y cloud-init epel-release"
boot_command = "<esc><wait>linux ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<wait><enter>"