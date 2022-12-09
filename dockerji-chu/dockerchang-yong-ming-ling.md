# docker常用命令

[TOC]

### 1.安装docker

```
yum install docker
```

### 2.查看版本

```
docker version
```

### 3.设置开机启动

```
CentOS6语法：
service docker start
chkconfig docker on

CentOS7语法：
systemctl start docker.service
systemctl enable docker.service
```

### 4.抓取/拉取镜像文件

```
docker pull image_name

#示例
[root@localhost ~]# docker pull mysql
Using default tag: latest # 如果不写tag，默认就是latest
latest: Pulling from library/mysql
b380bbd43752: Pull complete # 分层下载，docker image的核心 联合文件系统
f23cbf2ecc5d: Pull complete
30cfc6c29c0a: Pull complete
b38609286cbe: Pull complete
8211d9e66cd6: Pull complete
2313f9eeca4a: Pull complete
7eb487d00da0: Pull complete
a5d2b117a938: Pull complete
1f6cb474cd1c: Pull complete
896b3fd2ab07: Pull complete
532e67ebb376: Pull complete
233c7958b33f: Pull complete
Digest: sha256:5d52dc010398db422949f079c76e98f6b62230e5b59c0bf7582409d2c85abacb # 签名
Status: Downloaded newer image for mysql:latest
docker.io/library/mysql:latest # 真实地址

# 等价于它
docker pull mysql 等价于 docker pull docker.io/library/mysql:latest

# 指定版本下载
docker pull mysql:5.7

[root@localhost ~]# docker pull mysql:5.7
5.7: Pulling from library/mysql
b380bbd43752: Already exists
f23cbf2ecc5d: Already exists
30cfc6c29c0a: Already exists
b38609286cbe: Already exists
8211d9e66cd6: Already exists
2313f9eeca4a: Already exists
7eb487d00da0: Already exists
bb9cc5c700e7: Pull complete
88676eb32344: Pull complete
8fea0b38a348: Pull complete
3dc585bfc693: Pull complete
Digest: sha256:b8814059bbd9c80b78fe4b2b0b70cd70fe3772b3c5d8ee1edfa46791db3224f9
Status: Downloaded newer image for mysql:5.7
docker.io/library/mysql:5.7
```

### 5.运行镜像文件

```
docker run   XXX

OPTIONS说明：
-a stdin: 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；
-d: 后台运行容器，并返回容器ID；
-i: 以交互模式运行容器，通常与 -t 同时使用；
-P（大写）: 随机端口映射，容器内部端口随机映射到主机的高端口
-p: 指定端口映射，格式为：主机(宿主)端口:容器端口
-t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
--name="nginx-lb": 为容器指定一个名称；
--dns 8.8.8.8: 指定容器使用的DNS服务器，默认和宿主一致；
--dns-search example.com: 指定容器DNS搜索域名，默认和宿主一致；
-h "mars": 指定容器的hostname；
-e username="ritchie": 设置环境变量；
--env-file=[]: 从指定文件读入环境变量；
--cpuset="0-2" or --cpuset="0,1,2": 绑定容器到指定CPU运行；
-m :设置容器使用内存最大值；
--net="bridge": 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；
--link=[]: 添加链接到另一个容器；
--expose=[]: 开放一个端口或一组端口；
--volume , -v:	绑定一个卷



实例

#使用docker镜像nginx:latest以后台模式启动一个容器,并将容器命名为mynginx。
docker run --name mynginx -d nginx:latest

#使用镜像nginx:latest以后台模式启动一个容器,并将容器的80端口映射到主机随机端口。
docker run -P -d nginx:latest

#使用镜像 nginx:latest，以后台模式启动一个容器,将容器的 80 端口映射到主机的 80 端口,主机的目录 /data 映射到容器的 /data。
docker run -p 80:80 -v /data:/data -d nginx:latest

#绑定容器的 8080 端口，并将其映射到本地主机 127.0.0.1 的 80 端口上。
$ docker run -p 127.0.0.1:80:8080/tcp ubuntu bash

#使用镜像nginx:latest以交互模式启动一个容器,在容器内执行/bin/bash命令。
$ docker run -it nginx:latest /bin/bash
$:/# 

#从容器中退回主机
[root@8631de5eaae9 /]# exit
exit
[root@localhost ~]#

```

### 6.查看宿主机上的镜像，Docker镜像保存在/var/lib/docker目录下:

```
docker images
```

### 7.删除镜像  PS：b39c68b7af30是一个镜像Id

```
docker rmi  docker.io/tomcat:7.0.77-jre7   或者  docker rmi b39c68b7af30
```

### 8.查看当前有哪些容器正在运行

```
docker ps
```

### 9.查看所有容器

```
docker ps -a
```

### 10.启动、停止、重启容器命令：

```
docker start container_name/container_id
docker stop container_name/container_id
docker restart container_name/container_id
```

### 11.后台启动一个容器后，如果想进入到这个容器，可以使用attach命令：

```
docker attach container_name/container_id
```

### 12.删除容器的命令：

```
docker rm container_name/container_id
```

### 13.查看当前系统Docker信息

```
docker info
```

### 14.从Docker hub上下载某个镜像:

```
docker pull centos:latest
docker pull centos:latest
```

执行docker pull centos会将Centos这个仓库下面的所有镜像下载到本地repository。

### 15.docker search 搜索镜像

```
#基本使用
[root@localhost ~]# docker search mysql
NAME DESCRIPTION STARS OFFICIAL AUTOMATED
mysql MySQL is a widely used, open-source relation… 11543 [OK]
mariadb MariaDB Server is a high performing open sou… 4390 [OK]

#可选项，通过搜索来过滤
[root@localhost ~]# docker search mysql --filter=STARS=3000
NAME DESCRIPTION STARS OFFICIAL AUTOMATED
mysql MySQL is a widely used, open-source relation… 11543 [OK]
mariadb MariaDB Server is a high performing open sou… 4390 [OK]
```

### 16.docker查看日志

```
#查看日志
docker logs [OPTIONS] CONTAINER

OPTIONS说明：
-f : 跟踪日志输出
--since :显示某个开始时间的所有日志
-t : 显示时间戳
--tail :仅列出最新N条容器日志


#示例

#跟踪查看容器mynginx的日志输出。
runoob@runoob:~$ docker logs -f mynginx
192.168.239.1 - - [10/Jul/2016:16:53:33 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36" "-"
2016/07/10 16:53:33 [error] 5#5: *1 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 192.168.239.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "192.168.239.130", referrer: "http://192.168.239.130/"
192.168.239.1 - - [10/Jul/2016:16:53:33 +0000] "GET /favicon.ico HTTP/1.1" 404 571 "http://192.168.239.130/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36" "-"
192.168.239.1 - - [10/Jul/2016:16:53:59 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36" "-"
...

#查看容器mynginx从2016年7月1日后的最新10条日志。
docker logs --since="2016-07-01" --tail=10 mynginx
```

### 17.进入一个正在运行的docker容器

```
#示例一  进入容器后开启一个新的终端，可以在里面操作（常用）

[root@localhost ~]# docker exec -it 容器id /bin/bash


#示例二  进入容器正在执行的终端，不会启动新的进程

[root@localhost ~]# docker attach 97e2c02aa09f
```

### 18.从容器内拷贝文件到主机上

```
docker cp 容器id:容器内路径 目的主机路径
```

### 19.docker安装一个镜像且用完立即从容器删除

```
docker run -it --rm tomcat:9.0
```

### 20.--volume , -v:	映射一个卷（将容器的文件/文件夹绑定到主机的位置）

[docker挂载主机目录jar包/war包](../dockerying-yong-ff1a-gua-zai-wai-bu-mu-lu-jar-5305-war-bao.md)

### 21.docker 镜像导入和导出（docker 、export）

[菜鸟教程命令大全：docker save](https://www.runoob.com/docker/docker-save-command.html)

[菜鸟教程命令大全：docker load](https://www.runoob.com/docker/docker-load-command.html)

[采集教程命令大全：docker export](https://www.runoob.com/docker/docker-export-command.html)

[菜鸟教程命令大全：docker import](https://www.runoob.com/docker/docker-import-command.html)

#### 简写

#### 使用 export 和 import

- 查看本机的容器

  这两个命令是通过容器来导入、导出镜像。首先我们使用 docker ps -a 命令查看本机所有的容器。

- 导出镜像

  使用 docker export 命令根据容器 ID 将镜像导出成一个文件。

```
docker export f299f501774c > /mydata/export_container.tar
```

- 导入镜像

```
docker import new_export_container < /mydata/export_container.tar
```

#### 使用 save 和 load

单个镜像导出

```
[root@localhost ~]# docker save -o /mydata/hello.tar hello-world
或根据镜像Id 导出
[root@localhost ~]# docker save 123sewqe21312 > /mydata/hello.tar
```

多个镜像导出

```
[root@localhost ~]# docker save -o /mydata/back.tar nginx hello-world
```

> ```
> docker save [OPTIONS] IMAGE [IMAGE...]
> ```

镜像导入

```
[root@localhost ~]# docker load < hello.tar
```

#### 两种方案的差别

特别注意：两种方法不可混用。
如果使用 import 导入 save 产生的文件，虽然导入不提示错误，但是启动容器时会提示失败，会出现类似"docker: Error response from daemon: Container command not found or does not exist"的错误。

**1，文件大小不同**

export 导出的镜像文件体积小于 save 保存的镜像

**2，是否可以对镜像重命名**

docker import 可以为镜像指定新名称
docker load 不能对载入的镜像重命名

**3，是否可以同时将多个镜像打包到一个文件中**

docker export 不支持
docker save 支持

**4，是否包含镜像历史**

export 导出（import 导入）是根据容器拿到的镜像，再导入时会丢失镜像所有的历史记录和元数据信息（即仅保存容器当时的快照状态），所以无法进行回滚操作。
而 save 保存（load 加载）的镜像，没有丢失镜像的历史，可以回滚到之前的层（layer）。

**5，应用场景不同**

docker export 的应用场景：主要用来制作基础镜像，比如我们从一个 ubuntu 镜像启动一个容器，然后安装一些软件和进行一些设置后，使用 docker export 保存为一个基础镜像。然后，把这个镜像分发给其他人使用，比如作为基础的开发环境。
docker save 的应用场景：如果我们的应用是使用 docker-compose.yml 编排的多个镜像组合，但我们要部署的客户服务器并不能连外网。这时就可以使用 docker save 将用到的镜像打个包，然后拷贝到客户服务器上使用 docker load 载入。



### 22.Docker 容器镜像删除

1.停止所有的container，这样才能够删除其中的images：

docker stop $\(docker ps -a -q\)

如果想要删除所有container的话再加一个指令：

docker rm $\(docker ps -a -q\)

2.查看当前有些什么images

docker images

3.删除images，通过image的id来指定删除谁

docker rmi &lt;image id&gt;

想要删除untagged images，也就是那些id为&lt;None&gt;的image的话可以用

docker rmi $\(docker images \| grep "^&lt;none&gt;" \| awk "{print $3}"\)

要删除全部image的话

docker rmi $\(docker images -q\)

```text
# 关闭所有正在运行容器
docker ps | awk  '{print $1}' | xargs docker stop

# 删除所有容器应用
docker ps -a | awk  '{print $1}' | xargs docker rm
# 或者
docker rm $(docker ps -a -q)
```

### 23.卸载docker

```
sudo yum remove docker-ce docker-ce-cli containerd.io

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
```

### 24.网络命令
新建
```text
docker network create -d bridge test-net
```
查看网络详情
```text
docker network inspect test-net
```
容器加入指定网络
```text
# 创建mysql容器并加入到 `docker-mount_default` 网络
docker run -p 3367:3306 \
--name mysql02 \
-e MYSQL_ROOT_PASSWORD=123456 \
-v /home/mysql02/data:/var/lib/mysql \
--net docker-mount_default \
-d mysql
```
> 具体参考 [docker容器互联](../docker容器互联.md)

刪除
```text
docker network rm [networkID/NAME]
```


官方文档：https://docs.docker.com/reference/

参考菜鸟教程：https://www.runoob.com/docker/centos-docker-install.html



