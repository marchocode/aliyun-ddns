FROM ubuntu

ENV TZ=Asia/Shanghai
RUN apt update && apt -y install cron curl jq

RUN curl -o aliyun-cli-linux-latest-amd64.tgz https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-amd64.tgz && tar -zxvf aliyun-cli-linux-latest-amd64.tgz && rm -rf aliyun-cli-linux-latest-amd64.tgz
RUN mv aliyun /usr/bin

COPY task.sh .
COPY entrypoint.sh .
COPY custom /etc/cron.d/custom

RUN chmod 0644 /etc/cron.d/custom && chmod 0744 task.sh && chmod 0744 entrypoint.sh

RUN crontab /etc/cron.d/custom

CMD ["cron","-f", "-L", "2"]

ENTRYPOINT [ "/entrypoint.sh" ]