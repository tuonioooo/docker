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
service docker start
chkconfig docker on
```

4.抓取/拉取镜像文件

```
docker pull  image_name
```

5.运行镜像文件

```
docker run   XXX
```

6.查看宿主机上的镜像，Docker镜像保存在/var/lib/docker目录下:

```
docker images
```

7.删除镜像

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

