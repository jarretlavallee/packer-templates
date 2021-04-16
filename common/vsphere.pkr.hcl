
variable "boot_command" {
  type = string
}

variable "cpus" {
  type    = string
  default = "1"
}

variable "disk_size" {
  type    = string
  default = "32768"
}

variable "guest_type" {
  type = string
}

variable "iso_name" {
  type = string
}

variable "iso_path" {
  type    = string
  default = "[local] isos/"
}

variable "os_name" {
  type = string
}

variable "os_version" {
  type = string
}

variable "provision_commands" {
  type    = string
  default = "hostname"
}

variable "ram" {
  type    = string
  default = "2048"
}

variable "ssh_password" {
  type      = string
  default   = "${env("SSH_PASSWORD")}"
  sensitive = true
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "vsphere_cluster" {
  type    = string
  default = "Cluster"
}

variable "vsphere_datacenter" {
  type    = string
  default = "DC"
}

variable "vsphere_datastore" {
  type    = string
  default = "vsanDatastore"
}

variable "vsphere_folder" {
  type    = string
  default = "Templates"
}

variable "vsphere_host" {
  type    = string
  default = "${env("VSPHERE_HOST")}"
}

variable "vsphere_network" {
  type    = string
  default = "VM Network"
}

variable "vsphere_password" {
  type      = string
  default   = "${env("VSPHERE_PASSWORD")}"
  sensitive = true
}

variable "vsphere_server" {
  type    = string
  default = "${env("VSPHERE_SERVER")}"
}

variable "vsphere_user" {
  type    = string
  default = "${env("VSPHERE_USER")}"
}

variable "floppy_files" {
  type = string
  default = ""
}

variable "config_params" {
  default = {}
}

locals {
  builddate = formatdate("YYYY-MM-DD", timestamp())
  os_directory   = "${path.root}/../templates/${var.os_name}/${var.os_version}"
  http_directory = "${local.os_directory}"
  template_name  = "${var.os_name}-${var.os_version}-${local.builddate}"
  floppies       = "${local.os_directory}/${var.floppy_files}"
}

source "vsphere-iso" "vsphere" {
  CPUs                 = "${var.cpus}"
  RAM                  = "${var.ram}"
  RAM_reserve_all      = false
  boot_command         = ["${var.boot_command}"]
  cluster              = "${var.vsphere_cluster}"
  datacenter           = "${var.vsphere_datacenter}"
  datastore            = "${var.vsphere_datastore}"
  disk_controller_type = ["pvscsi"]
  floppy_files         = ["${local.floppies}"]
  folder               = "${var.vsphere_folder}"
  guest_os_type        = "${var.guest_type}"
  host                 = "${var.vsphere_host}"
  http_directory       = "${local.http_directory}"
  insecure_connection  = "true"
  iso_paths            = ["${var.iso_path}${var.iso_name}"]
  network_adapters {
    network      = "${var.vsphere_network}"
    network_card = "vmxnet3"
  }
  password     = "${var.vsphere_password}"
  ssh_password = "${var.ssh_password}"
  ssh_username = "${var.ssh_username}"
  storage {
    disk_size             = "${var.disk_size}"
    disk_thin_provisioned = true
  }
  username       = "${var.vsphere_user}"
  vcenter_server = "${var.vsphere_server}"
  vm_name        = "${local.template_name}"
  configuration_parameters = var.config_params
}

build {
  sources = ["source.vsphere-iso.vsphere"]

  provisioner "shell" {
    execute_command = "echo 'packer'|{{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    inline          = ["${var.provision_commands}"]
  }

}
