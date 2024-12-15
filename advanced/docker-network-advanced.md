# Docker network进阶配置
```plain
docker run -p 3367:3306 \
--name mysql02 \
-e MYSQL_ROOT_PASSWORD=123456 \
-v /home/mysql02/data:/var/lib/mysql \
--net docker-mount_default \
-d mysql
```

