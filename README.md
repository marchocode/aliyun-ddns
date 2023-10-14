## aliyun DDNS in Docker
It will update your public ip into domain record 10 mins again.

### Get Start

```docker
docker run -d --name aliyun-ddns \
-e AK_ID=xxx \
-e AK_SECRET=xxx \
-e DOMAIN=xxx.example.com \
marchocode/aliyun-ddns:latest
```