# docker常用命令

1.安装docker

```
yum install docker
```

2.查看版本

```
docker version
```

3.设置开机启动

```
CentOS6语法：
service docker start
chkconfig docker on

CentOS7语法：
systemctl start docker.service
systemctl enable docker.service
```

4.抓取/拉取镜像文件

```
docker pull  image_name
```

5.运行镜像文件

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


```

6.查看宿主机上的镜像，Docker镜像保存在/var/lib/docker目录下:

```
docker images
```

7.删除镜像  PS：b39c68b7af30是一个镜像Id

```
docker rmi  docker.io/tomcat:7.0.77-jre7   或者  docker rmi b39c68b7af30
```

8.查看当前有哪些容器正在运行

```
docker ps
```

9.查看所有容器

```
docker ps -a
```

10.启动、停止、重启容器命令：

```
docker start container_name/container_id
docker stop container_name/container_id
docker restart container_name/container_id
```

11.后台启动一个容器后，如果想进入到这个容器，可以使用attach命令：

```
docker attach container_name/container_id
```

12.删除容器的命令：

```
docker rm container_name/container_id
```

13.查看当前系统Docker信息

```
docker info
```

14.从Docker hub上下载某个镜像:

```
docker pull centos:latest
docker pull centos:latest
```

执行docker pull centos会将Centos这个仓库下面的所有镜像下载到本地repository。

# Docker 容器镜像删除

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

