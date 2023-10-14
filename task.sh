#!/usr/bin/env bash

ip=$(curl -s http://myip.ipip.net)

env

echo $1;

cat /etc/environment

if [[ $ip =~ [0-9.]+ ]]; 
then 
  echo "Your ip address "${BASH_REMATCH[0]}
  ipaddress=${BASH_REMATCH[0]}
else 
  exit 0
fi

aliyun alidns DescribeSubDomainRecords --region cn-chengdu --SubDomain ${DOMAIN} > record.json
cat record.json

Value=$(jq --raw-output '.DomainRecords.Record|.[0].Value' record.json)

if [[ $Value == $ipaddress ]];
then
  echo "Ip is not changed. exit."
  exit 0
fi


recordId=$(jq --raw-output '.DomainRecords.Record|.[0].RecordId' record.json)
RR=$(jq --raw-output '.DomainRecords.Record|.[0].RR' record.json)
Type=$(jq --raw-output '.DomainRecords.Record|.[0].Type' record.json)

echo $recordId
echo $RR
echo $Type

aliyun alidns UpdateDomainRecord --region cn-chengdu --RecordId $recordId --RR $RR --Type $Type --Value ${ipaddress}

echo "Success"