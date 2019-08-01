#!/bin/bash
set -eu -o pipefail


eval "$(jq -r '@sh "export ssh_user=\(.ssh_user) ssh_key=\(.ssh_key) ssh_pass=\(.ssh_pass) server_ip=\(.server_ip) tmp_file=\(.tmp_file) jq_path=\(.jq_path)"')"

ssh-keyscan -H ${server_ip} >> ~/.ssh/known_hosts 2>/dev/null

if [[ ! -z "${ssh_key}" ]]; then
  ssh -i ${ssh_key} ${ssh_user}@${server_ip} "cat ${tmp_file} | ${jq_path} '.'"
else 
  if ! hash sshpass; then
    echo "must install sshpass"
    exit 1
  else
    sshpass -p ${ssh_pass} ssh ${ssh_user}@${server_ip} "cat ${tmp_file} | ${jq_path} '.'"
  fi
fi
