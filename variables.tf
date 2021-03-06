################## connection #####################

variable "ip" {
  description = "The ip address where chef-solo will run"
  type        = string
}

variable "user_name" {
  description = "The ssh or winrm user name used to access the ip addresses provided"
  type        = string
}

variable "user_pass" {
  description = "The ssh or winrm user password used to access the ip addresses (either user_pass or user_private_key needs to be set)"
  type        = string
  default     = ""
}

variable "user_private_key" {
  description = "The ssh user key used to access the ip addresses (either user_pass or user_private_key needs to be set)"
  type        = string
  default     = ""
}

variable "timeout" {
  description = "The timeout to wait for the connection to become available. Should be provided as a string like 30s or 5m, Defaults to 5 minutes."
  type        = string
  default     = "5m"
}

################# misc ############################

variable "system_type" {
  description = "The system type linux or windows"
  type        = string
  default     = "linux"
}

variable "linux_tmp_path" {
  description = "The location of a temp directory to store install scripts on"
  type        = string
  default     = "/var/tmp"
}

variable "windows_installer_name" {
  description = "The name of the windows chef install script"
  type        = string
  default     = "installer.ps1"
}

variable "linux_installer_name" {
  description = "The name of the linux chef install script"
  type        = string
  default     = "installer.sh"
}

variable "jq_windows_url" {
  description = "A url to a jq binary to download, used in the install process"
  type        = string
  default     = "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe"
}

variable "jq_linux_url" {
  description = "A url to a jq binary to download, used in the install process"
  type        = string
  default     = "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
}

################# chef run ########################

variable "chef_bootstrap_version" {
  description = "The version of chef workstaion to install"
  type        = string
  default     = "0.7.4"
}

variable "policyfile" {
  description = "Use this variable to pass through a policy file to run"
  type        = string
  default     = ""
}

variable "dna" {
  description = "A map of JSON strings of chef attributes to apply to the chef-solo runs of each ip address"
  type        = map
  default     = {}
}

variable "policyfile_name" {
  description = "The name to give the auto generated policyfile (used if the policyfile variable is set to an empty string"
  type        = string
  default     = "base"
}

variable "default_source" {
  description = "The default source to use in the auto generated policyfile"
  type        = string
  default     = ":supermarket"
}

variable "runlist" {
  description = "The runlist to pass through to the auto generated policyfile"
  type        = list
  default     = []
}

variable "cookbooks" {
  description = "The cookbook names, locations and versions to pass through to the auto generated policyfile"
  default     = {}
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on"
  type        = list(any)
  default     = []
}
