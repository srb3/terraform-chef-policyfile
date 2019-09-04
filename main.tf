locals {
  instance_count = var.instance_count # length(var.ips)
  cmd            = var.system_type == "linux" ? "bash" : "powershell.exe"
  mkdir          = var.system_type == "linux" ? "mkdir -p" : "New-Item -ItemType Directory -Force -Path"
  tmp_path       = var.system_type == "linux" ? "${var.linux_tmp_path}/${var.policyfile_name}" : "C:\\Users\\${var.user_name}\\AppData\\Local\\Temp\\${var.policyfile_name}"
  installer_name = var.system_type == "linux" ? var.linux_installer_name : var.windows_installer_name
  installer      = templatefile("${path.module}/templates/installer", {
    system                 = var.system_type,
    chef_bootstrap_version = var.chef_bootstrap_version,
    tmp_path               = local.tmp_path,
    policyfile_name        = var.policyfile_name,
    jq_windows_url         = var.jq_windows_url,
    jq_linux_url           = var.jq_linux_url
  })
  policyfile = var.policyfile != "" ? var.policyfile : templatefile("${path.module}/templates/Policyfile.rb", {
    name           = var.policyfile_name,
    default_source = var.default_source,
    runlist        = var.runlist,
    cookbooks      = var.cookbooks
  })
}

resource "null_resource" "chef_run" {
  count    = local.instance_count

  triggers = {
    data = md5(jsonencode(var.dna))
    ips = md5(join(",", var.ips))
    policyfile = md5(local.policyfile)
  }

  connection {
    type        = var.system_type == "windows" ? "winrm" : "ssh"
    user        = var.user_name
    password    = var.user_pass
    private_key = var.user_private_key != "" ? file(var.user_private_key) : null
    host        = var.ips[count.index]
    timeout     = var.timeout
  }

  provisioner "remote-exec" {
    inline = [
      "${local.mkdir} ${local.tmp_path}"
    ]
  }

  provisioner "file" {
    content     = local.installer
    destination = "${local.tmp_path}/${local.installer_name}"
  }

  provisioner "file" {
    content     = var.hook_data
    destination = "${local.tmp_path}/hook_data.json"
  }

  provisioner "file" {
    content     = local.policyfile
    destination = "${local.tmp_path}/Policyfile.rb"
  }

  provisioner "file" {
    content     = length(var.module_inputs) != 0 ? jsonencode(var.module_inputs[count.index]) : jsonencode({"dummy" = "data"})
    destination = "${local.tmp_path}/dna_extra.json"
  }

  provisioner "file" {
    content     = length(var.dna) != 0 ? jsonencode(var.dna[count.index]) : jsonencode({"mock" = "data"})
    destination = "${local.tmp_path}/dna_base.json"
  }

  provisioner "remote-exec" {
    inline = [
      "${local.cmd} ${local.tmp_path}/${local.installer_name}"
    ]
  }
}

data "external" "module_hook" {
  count = var.system_type == "windows" ? 0 : local.instance_count
  program    = ["bash", "${path.module}/files/data_source.sh"]
  depends_on = ["null_resource.chef_run"]

  query = {
    ssh_user              = var.user_name
    ssh_pass              = var.user_pass
    ssh_key               = var.user_private_key
    server_ip             = var.ips[count.index]
    tmp_file              = "${local.tmp_path}/hook_read_back.json"
    jq_path               = "${local.tmp_path}/bin/jq"
  }
}
