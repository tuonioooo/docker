# Docker 安装 CentOS

CentOS（Community Enterprise Operating System）是 Linux 发行版之一，它是来自于 Red Hat Enterprise Linux(RHEL) 依照开放源代码规定发布的源代码所编译而成。由于出自同样的源代码，因此有些要求高度稳定性的服务器以 CentOS 替代商业版的 Red Hat Enterprise Linux 使用。

### 1、查看可用的 CentOS 版本
访问 CentOS 镜像库地址：[https://hub.docker.com/_/centos?tab=tags&page=1](https://hub.docker.com/_/centos?tab=tags&page=1)。

可以通过 Sort by 查看其他版本的 CentOS 。默认是最新版本 centos:latest 。

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160359347-3415924c-7e8f-4194-92ae-70af7e4e8ffa.png)

你也可以在下拉列表中找到其他你想要的版本：

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160359347-c06363e0-f7f4-415b-8ef2-7a4f9a091902.png)

### 2、拉取指定版本的 CentOS 镜像，这里我们安装指定版本为例(centos7):
```json
$ docker pull centos:centos7
```

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160359285-dac4f954-f668-4573-8226-fe167e65b10b.png)

### 3、查看本地镜像
使用以下命令来查看是否已安装了 centos7：

```json
$ docker images
```

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160359306-6b3e9631-ead1-442d-9b7c-1e380b5a5cf8.png)

### 4、运行容器，并且可以通过 exec 命令进入 CentOS 容器。
```json
$ docker run -itd --name centos-test centos:centos7
```

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160359348-5148e3aa-764a-4f1e-b383-ea760947be7d.png)

### 5、安装成功
最后我们可以通过 **docker ps** 命令查看容器的运行信息：

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734160360011-e5882e1e-9f88-4841-bb50-c45c252bf758.png)

