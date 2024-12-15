# Docker 安装 Ubuntu

Ubuntu 是基于 Debian 的 Linux 操作系统。

### 1、查看可用的 Ubuntu 版本
访问 Ubuntu 镜像库地址： [https://hub.docker.com/_/ubuntu?tab=tags&page=1](https://hub.docker.com/_/ubuntu?tab=tags&page=1)。

可以通过 Sort by 查看其他版本的 Ubuntu。默认是最新版本 ubuntu:latest 。

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160288437-4d41bd64-28c5-4a23-acde-a1bad945a272.png)

你也可以在下拉列表中找到其他你想要的版本：

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160288398-d06f967a-8903-4445-b0ec-3ae9811bfec5.png)

### 2、拉取最新版的 Ubuntu 镜像
```json
$ docker pull ubuntu
```

或者：

```json
$ docker pull ubuntu:latest
```

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160288279-c4cd5bbd-e2e6-40d7-b887-4c23bb8e51a9.png)

### 3、查看本地镜像
```json
$ docker images
```

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160288241-8945b2c6-b58c-4101-993c-4da4036c0f61.png)

在上图中可以看到我们已经安装了最新版本的 ubuntu。

### 4、运行容器，并且可以通过 exec 命令进入 ubuntu 容器
```json
$ docker run -itd --name ubuntu-test ubuntu
```

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160288240-fb0ecd8f-36c7-4553-b171-dc98a9d5c264.png)

### 5、安装成功
```json
最后我们可以通过 docker ps 命令查看容器的运行信息：
```

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160288550-0204662f-75df-40d6-87ba-692985a775d7.png)

