#!/bin/bash
set -eu -o pipefail


eval "$(jq -r '@sh "export ssh_user=\(.ssh_user) ssh_key=\(.ssh_key) ssh_pass=\(.ssh_pass) server_ip=\(.server_ip) tmp_file=\(.tmp_file)"')"

ssh-keyscan -H ${server_ip} >> ~/.ssh/known_hosts 2>/dev/null

if [[ ! -z "${ssh_key}" ]]; then
  echo "ssh -i ${ssh_key} ${ssh_user}@${server_ip} \"cat ${tmp_file} | jq '.'\"" > /tmp/ds_pk.txt
  ssh -i ${ssh_key} ${ssh_user}@${server_ip} "cat ${tmp_file} | jq '.'"
else 
  if ! hash sshpass; then
    echo "must install sshpass"
    exit 1
  else
    echo "sshpass -p ${ssh_pass} ssh ${ssh_user}@${server_ip} \"cat ${tmp_file} | jq '.'\"" > /tmp/ds_pwd.txt
    sshpass -p ${ssh_pass} ssh ${ssh_user}@${server_ip} "cat ${tmp_file} | jq '.'"
  fi
fi
