# docker-compose安装redis

### docker-compose 安装

[docker-compose 安装](../manual/docker-compose-run-command.md)

### 编写docker-compose.yml文件

```yml
version: '3' #指定版本
services:    #服务根节点
  redis:     #redis服务/其他服务（web服务/nginx服务等）
      image: redis:7                            #redis镜像，如果镜像容器没有会去自动拉取
      container_name: redis                     #设置容器名称
      command: redis-server --appendonly yes --requirepass '123456'    #开启持久化的支持并设置认证密码
      restart: always                           #跟随docker的启动而启动
      volumes:
        - /mydata/redis/data:/data              #数据文件挂载
      ports:
        - 6379:6379
```

### 部署

#### 准备工作

创建目录

```shell
$ mkdir -p /mydata/redis/data
```

将 `docker-compose.yml` 文件上传到Linux服务器 `/mydata` 目录下

#### 启动redis

```shell
$ cd /mydata
$ docker-compose up redis -d  #指定redis 后台运行
[+] Running 1/1
 ⠿ Container redis  Started   
```

验证

```shell
[root@localhost ~]# docker exec -it redis redis-cli
127.0.0.1:6379> set name allen
(error) NOAUTH Authentication required.
127.0.0.1:6379> auth 123456
OK
127.0.0.1:6379> set name allen
OK
127.0.0.1:6379> get name
"allen"
```

### 常用命令


[docker-compose常用命令](./docker-compose-common-command.md)
