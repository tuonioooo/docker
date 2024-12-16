# Docker 安装 Ubuntu

Ubuntu 是基于 Debian 的 Linux 操作系统。

### 1、查看可用的 Ubuntu 版本
访问 Ubuntu 镜像库地址： [https://hub.docker.com/_/ubuntu?tab=tags&page=1](https://hub.docker.com/_/ubuntu?tab=tags&page=1)。

可以通过 Sort by 查看其他版本的 Ubuntu。默认是最新版本 ubuntu:latest 。

![](../assets/install/ubuntu1.png)

你也可以在下拉列表中找到其他你想要的版本：

![](../assets/install/ubuntu2.png)

### 2、拉取最新版的 Ubuntu 镜像

```shell
docker pull ubuntu
```

或者：

```shell
docker pull ubuntu:latest
```

![](../assets/install/ubuntu3.png)

### 3、查看本地镜像

```shell
docker images
```

![](../assets/install/ubuntu4.png)

在上图中可以看到我们已经安装了最新版本的 ubuntu。

### 4、运行容器，并且可以通过 exec 命令进入 ubuntu 容器

```shell
docker run -itd --name ubuntu-test ubuntu
$ docker exec -it ubuntu-test /bin/bash
```

![](../assets/install/ubuntu5.png)

### 5、安装成功

最后我们可以通过 `docker ps` 命令查看容器的运行信息：

![](../assets/install/ubuntu6.png)

