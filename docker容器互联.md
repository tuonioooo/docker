# docker容器互联

## --link互联

启动mysql容器，暴露端口 `3306`

```text
docker run -p 3306:3306 \
--name mysql \ #容器名
-e MYSQL_ROOT_PASSWORD=root \ #设置root账号密码
-v /mnt/docker-mnt/mysql/data:/var/lib/mysql \
-d mysql
```

启动Java容器，通过--link 链接 mysql、redis容器

```text
docker run -p 9330:9330 --name miliqk-manage-platform \ #容器的名称
-e TZ="Asia/Shanghai" \
-e APP_PROFILE=dev \
-v /etc/localtime:/etc/localtime \
-v /home/daizhao/apps/miliqk-manage-platform/logs:/logs \
--link mysql:db \ #容器名:别名
--link redis \
-d miliqk-manage-platform:0.0.1-SNAPSHOT #镜像名称:版本
```

进入miliqk-manage-platform容器 ，ping mysql、redis 查看ping的效果

![](assets/docker-link.png)

`application.yml`配置数据源说明

```
jdbc:mysql://db:3306/miliqk_mp?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true
```

> `db` 是容器的别名，同时也可以用 容器名 `mysql`，或用 `mysql` 容器的ip  
> `3306` 是容器的端口号，不是对外暴露的端口切记

## --net 网络互连bridge网桥模式

创建一个bridge网络命名`docker-mount_default`

```text
docker network create -d bridge docker-mount_default

[root@ecs-149911 ~]# docker network ls
NETWORK ID     NAME                   DRIVER    SCOPE
f297f786d4b5   bridge                 bridge    local
c3509a01b631   docker-mount_default   bridge    local
f7f0029f747b   host                   host      local
454e6fbe8a40   none                   null      local
```
> 参数说明：  
-d：参数指定 Docker 网络类型，有 bridge、overlay。  
其中 overlay 网络类型用于 Swarm mode，在本小节中你可以忽略它。

运行容器mysql并加入到`docker-mount_default`网络

```text
# 创建mysql容器并加入到 `docker-mount_default` 网络
docker run -p 3367:3306 \
--name mysql02 \
-e MYSQL_ROOT_PASSWORD=123456 \
-v /home/mysql02/data:/var/lib/mysql \
--net docker-mount_default \
-d mysql

# 创建Java容器并加入到 `docker-mount_default` 网络
docker run -p 9330:9330 --name miliqk-manage-platform \ #容器的名称
-e TZ="Asia/Shanghai" \
-e APP_PROFILE=dev \
-v /etc/localtime:/etc/localtime \
-v /home/daizhao/apps/miliqk-manage-platform/logs:/logs \
--net docker-mount_default \ 
-d miliqk-manage-platform:0.0.1-SNAPSHOT #镜像名称:版本
```

进入到`miliqk-manage-platform`容器 ping mysql02 查看效果

```text
docker exec -it miliqk-manage-platform bash
root@28443415a16f:/# ping mysql02
PING mysql (172.18.0.3): 56 data bytes
64 bytes from 172.18.0.3: icmp_seq=0 ttl=64 time=0.065 ms
64 bytes from 172.18.0.3: icmp_seq=1 ttl=64 time=0.084 ms
64 bytes from 172.18.0.3: icmp_seq=2 ttl=64 time=0.082 ms
64 bytes from 172.18.0.3: icmp_seq=3 ttl=64 time=0.097 ms
```

进入到`mysql02`容器 ping miliqk-manage-platform 查看效果

```text
[root@ecs-149911 ~]# docker exec -it mysql02 bash
root@ecf2f7975ad8:/# ping miliqk-manage-platform
PING miliqk-manage-platform (172.18.0.5) 56(84) bytes of data.
64 bytes from miliqk-manage-platform.docker-mount_default (172.18.0.5): icmp_seq=1 ttl=64 time=0.077 ms
64 bytes from miliqk-manage-platform.docker-mount_default (172.18.0.5): icmp_seq=2 ttl=64 time=0.058 ms
64 bytes from miliqk-manage-platform.docker-mount_default (172.18.0.5): icmp_seq=3 ttl=64 time=0.057 ms
```

> 容器内中无 ping 命令，则在容器内执行以下命令安装 ping。  
`apt-get update`  
`apt install iputils-ping`


两者都可以互ping通，说明两个容器互联成功，也可以通过ip访问，容器的ip如何查看

```text
#检查`docker-mount_default`网络的详情
docker network inspect docker-mount_default
#....other
"Containers": {
            "28443415a16f053ddbe577efb9bfa00df2241395fd84506b6adcf47aee6214b4": {
                "Name": "miliqk-manage-platform",
                "EndpointID": "23c52d4d23198386c2737197f45c7d67ae0fd97d9c8b452360cbd794c5c0fc7d",
                "MacAddress": "02:42:ac:12:00:05",
                "IPv4Address": "172.18.0.5/16",
                "IPv6Address": ""
            },
            "ecf2f7975ad813ce34241b465596699e722808f4f37d9b99dc65c87397c0a28a": {
                "Name": "mysql02",
                "EndpointID": "ad4fc6d96de58bcb33506be09713cb451acf4731b31449c5911e8a46a82446bf",
                "MacAddress": "02:42:ac:12:00:06",
                "IPv4Address": "172.18.0.6/16",
                "IPv6Address": ""
            }
#....other
```
通过以上命令，可以查看到每一个容器所在网络中的ip，进入到容器`miliqk-manage-platform`用ip访问mysql02

```text
docker exec -it miliqk-manage-platform bash
root@28443415a16f:/# ping 172.18.0.6
PING 172.18.0.6 (172.18.0.6): 56 data bytes
64 bytes from 172.18.0.6: icmp_seq=0 ttl=64 time=0.090 ms
64 bytes from 172.18.0.6: icmp_seq=1 ttl=64 time=0.072 ms
64 bytes from 172.18.0.6: icmp_seq=2 ttl=64 time=0.085 ms
64 bytes from 172.18.0.6: icmp_seq=3 ttl=64 time=0.071 ms
```

删除一个网络的命令

```text
docker network rm [networkID/NAME]
```

## 参考文档

官方文档：[https://docs.docker.com/engine/reference/commandline/run/#connect-a-container-to-a-network---network](https://docs.docker.com/engine/reference/commandline/run/#connect-a-container-to-a-network---network)

第三方文档：[http://www.manongjc.com/detail/29-kroiethkfgtpeno.html](http://www.manongjc.com/detail/29-kroiethkfgtpeno.html)


