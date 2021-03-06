# Overview
This terraform module will access a server and create a cookbook artifact from a policyfile, and then run chef-solo against that artifact

### Supported platform families:
 * Debian
 * SLES
 * RHEL

## Usage

```hcl

module "chef_server" {
  source           = "devoptimist/policyfile/chef"
  version          = "0.0.12"
  ips              = ["172.16.0.23"]
  instance_count   = 1
  user_name        = "ec2-user"
  user_private_key = "~/.ssh/id_rsa"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|ips|A list of ip addresses where chef-solo will run|list|[]|no|
|instance_count|The number of instances that will have chef-solo run on them| integer |0|no|
|user_name|The ssh or winrm user name used to access the ip addresses provided|string||yes|
|user_pass|The ssh or winrm user password used to access the ip addresses (either user_pass or user_private_key needs to be set)|string|""|no|
|user_private_key|The ssh user key used to access the ip addresses (either user_pass or user_private_key needs to be set)|string|""|no|
|hook_data|If you need this module to depend on the output of another module/resource use this variable to store its output|string|"{}"|no|
|system_type|The system type linux or windows|string|linux|no|
|linux_tmp_path|The location of a temp directory to store install scripts on|string|/var/tmp|no|
|windows_installer_name|The name of the windows chef install script|string|installer.ps1|no|
|linux_installer_name|The name of the linux chef install script|string|installer.sh|no|
|jq_windows_url|A url to a jq binary to download, used in the install process|string|https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe|no|
|jq_linux_url|A url to a jq binary to download, used in the install process|string|https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64|no|
|chef_bootstrap_version|The version of chef workstaion to install|string|0.7.4|no|
|policyfile|Use this variable to pass through a policy file to run|string|""|no|
|dna|A list JSON strings of chef attributes to apply to the chef-solo runs of each ip address|list|[]|no|
|policyfile_name|The name to give the auto generated policyfile (used if the policyfile variable is set to an empty string|string|""|no|
|default_source|The default source to use in the auto generated policyfile|string|:supermarket|no|
|runlist|The runlist to pass through to the auto generated policyfile|list|[]|no|
|cookbooks|The cookbook names, locations and versions to pass through to the auto generated policyfile|map|{}|no|
|module_depends_on|List of modules or resources this module depends on|list|[]|no| 
