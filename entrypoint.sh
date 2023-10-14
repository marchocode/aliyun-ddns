#!/bin/bash
printenv | grep -v "PATH" | grep -v "PWD" >> /etc/environment

aliyun configure set \
  --profile def \
  --mode AK \
  --region cn-chengdu \
  --access-key-id ${AK_ID} \
  --access-key-secret ${AK_SECRET}

aliyun configure list

echo "$@"
exec "$@"