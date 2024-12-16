# docker-compose网络配置

## 默认网络

假设您的应用程序位于名为的目录中docker-mount，示例docker-compose.yml样式如下：

```text
version: '3'
services:
  jenkins:
    image: jenkins/jenkins:lts    #镜像名称
    container_name: jenkins       #设置容器名称
    #user: root                   #使用root用户启动
    user: 1000:994                #uid=1000(daizhao) gid=1000(daizhao) 组=1000(daizhao),993(docker) 使用uid代替username 避免报错Error response from daemon: unable to find user ubuntuu: no matching entries in passwd file
    privileged: true              #拥有root用户的权限
    restart: always               #跟随docker的启动而启动
    environment:                  #设置环境变量
        JAVA_OPTS: '-Djava.util.logging.config.file=/var/jenkins_home/log.properties'
    volumes:
      - /mnt/data/docker-mount/jenkins/:/var/jenkins_home                     #挂载jenkins工作目录
      - /etc/localtime:/etc/localtime                                             #挂载时间                                  
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
      - /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7
    ports:
      - 8080:8080
    expose: #暴露给其他容器、link的端口号
      - 8080
      - 50000
  nginx:
    image: nginx:latest          #镜像名称 
    container_name: nginx        #设置容器名称
    restart: always              #跟随docker的启动而启动
    network_mode: host           #网络端口模式为主机 设置这个以后 不能再设置端口，类似docker --net: host
    volumes:                     #挂载卷命令
      - /mnt/data/docker-mount/nginx/conf/nginx.conf:/etc/nginx/nginx.conf                #映射配置文件入口文件
      - /mnt/data/docker-mount/nginx/html:/usr/share/nginx/html                           #nginx静态资源根目录挂载         
      - /mnt/data/docker-mount/nginx/logs:/var/log/nginx                                  #日志文件挂载        
      - /mnt/data/docker-mount/nginx/conf.d:/etc/nginx/conf.d                             #映射配置文件  
      - /home/daizhao/web:/home/daizhao/web                                                   #自定义扩展静态资源目录挂载
      - /home/daizhao/static:/home/daizhao/static                                             #自定义扩展静态资源目录挂载
    #ports:                       #宿主主机端口80 映射到 容器端口80
    # - 80:80   
  redis: 
    image: redis:latest          #镜像名称
    container_name: redis        #设置容器名称
    command: redis-server --appendonly yes --requirepass 'zbwZ1GqfPf7Kmx5*JS_s'   #开启持久化的支持并设置认证密码 
    restart: always  
    volumes:                     #跟随docker的启动而启动
      - /mnt/data/docker-mount/redis/data:/data                 #数据文件挂载
      - /mnt/data/docker-mount/redis/redis.conf:/usr/local/etc/redis.conf #配置文件挂载
    ports:                       #宿主主机端口6379 映射到 容器端口6379
      - 6379:6379
```

执行命令 `docker-compose up`，会默认创建一个`docker-mount_default`网络，同时启动的容器将会自动加入网络中，查看网络的详情命令如下：
```text
docker network inspect docker-mount_default
```
> 可以查看网络内的容器、ip等配置信息
> network_mode: host 该模式无法在集群模式下使用

容器互联

[docker容器互联](../usage/docker-container-connection.md)

## links

```text
version: "3.4"
services:
  redis-web:
    image: redis-web:1.0
    container_name: redis-web
    restart: always
    environment:
      REDIS_HOST: redis
    ports:
      - 8001:8001
    links:  # 链接到其它容器，并启别名redis
      - redis-app:redis
  redis-app:
    image: redis:latest
    container_name: redis-app
    restart: always
```

## external_links 用于链接到外部容器

首先，自定义一个网络net-a

```text
docker network create net-a --driver bridge
```

创建外部容器

```text
docker run --name redis-external --net net-a -d redis
```

部署docker-compose，使用外部网络net-a

```text
version: "3.4"
services:
  redis-web:
    image: redis-web:1.0
    container_name: redis-web
    restart: always
    environment: 
      REDIS_HOST: redis
    ports:
      - 8001:8001
    links:
      - redis-app:redis
  redis-web-external:
    image: redis-web:1.0
    container_name: redis-web-external
    restart: always
    environment:
      REDIS_HOST: redis-external
    ports:
      - 8002:8001
    external_links:
      - redis-external
  redis-app:
    image: redis:latest
    container_name: redis-app
    restart: always
networks:
  default:
    external:
      name: net-a
```

参考文档：

[https://stackoverflow.com/questions/35154441/docker-compose-links-vs-external-links](https://stackoverflow.com/questions/35154441/docker-compose-links-vs-external-links)
[https://blog.csdn.net/halcyonbaby/article/details/47904085](https://blog.csdn.net/halcyonbaby/article/details/47904085)
