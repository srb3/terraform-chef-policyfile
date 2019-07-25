################## connection #####################
variable "ips" {
  type    = list
  default = []
}

variable "instance_count" {
  default = 0
}

variable "ssh_user_name" {
  type    = string
  default = "chefuser"
}

variable "ssh_user_pass" {
  type    = string
  default = "P@55w0rd1"
}

variable "ssh_user_private_key" {
  type    = string
  default = ""
}

################# module hook #####################

variable "hook_data" {
  type    = string
  default = "{}"
}

################# misc ############################

variable "system_type" {
  type    = string
  default = "linux"
}

variable "linux_tmp_path" {
  type    = string
  default = "/var/tmp"
}

variable "windows_installer_name" {
  type    = string
  default = "installer.ps1"
}

variable "linux_installer_name" {
  type    = string
  default = "installer.sh"
}

################# chef run ########################
variable "tmp_path" {
  type    = string
  default = "/var/tmp"
}

variable "chef_bootstrap_version" {
  type    = string
  default = "0.4.2"
}

variable "policyfile" {
  type    = string
  default = ""
}

variable "dna" {
  type    = list
  default = []
}

variable "policyfile_name" {
  type    = string
  default = "base"
}

variable "default_source" {
  type    = string
  default = ":supermarket"
}

variable "runlist" {
  type    = list
  default = []
}

variable "cookbooks" {
  default = {}
}

variable "module_inputs" {
  type    = list
  default = []
}
