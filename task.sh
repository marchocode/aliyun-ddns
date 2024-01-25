#!/usr/bin/env bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

info() {
    date=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "${date}  INFO    ${1}"
}

debug(){
    date=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "${date}  DEBUG   ${1}"
}

warn(){
    date=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "${date}  ${yellow}WARN    ${1}${plain}"
}

error(){
    date=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "${date}  ${red}ERROR  ${1}${plain}"
}

ip=$(curl -s http://myip.chaobei.xyz)

if [[ $ip =~ [0-9.]+ ]]; 
then 
  info "Your ip address "${BASH_REMATCH[0]}
  ipaddress=${BASH_REMATCH[0]}
else 
  exit 0
fi

getRecordInfo(){

  DOMAIN=$1
  aliyun alidns DescribeSubDomainRecords --region cn-chengdu --SubDomain ${DOMAIN} > record.json || exit 1
  Value=$(jq --raw-output '.DomainRecords.Record|.[0].Value' record.json)

  info "Domain: ${DOMAIN} record Ip is ${Value}"

  if [[ $Value == $ipaddress ]];
  then
    info "Ip is not changed. exit."
    return 1
  fi

  return 0
}

updateRecord(){

  recordId=$(jq --raw-output '.DomainRecords.Record|.[0].RecordId' record.json)
  RR=$(jq --raw-output '.DomainRecords.Record|.[0].RR' record.json)
  Type=$(jq --raw-output '.DomainRecords.Record|.[0].Type' record.json)

  aliyun alidns UpdateDomainRecord --region cn-chengdu --RecordId $recordId --RR $RR --Type $Type --Value ${ipaddress} && info "Update Success"
}

export IFS=";"
for DOMAIN in $DOMAINS; do
  getRecordInfo $DOMAIN && updateRecord
done