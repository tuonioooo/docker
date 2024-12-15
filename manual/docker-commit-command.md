# Docker commit 命令

[Docker命令大全](./docker-command-manual.md)

`docker commit` 

命令用于将容器的当前状态保存为一个新的 Docker 镜像。

通常用于创建镜像来保存容器的状态，以便在将来可以重用或分发该镜像。

### 语法
docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]

OPTIONS说明：

+ **-a :**提交的镜像作者。
+ **-c :**使用 Dockerfile 指令来创建镜像。
+ **-m :**提交时的说明文字。
+ **-p :**提交镜像前暂停容器（默认为 true）。

例：将名为 my_container 的容器保存为一个名为 my_new_image 的新镜像。

```shell
docker commit my_container my_new_image
```

例：将容器保存为带有 latest 标签的镜像。

```shell
docker commit my_container my_new_image:latest
```

例：将容器保存为新镜像，并添加作者信息和提交信息。

```shell
docker commit -a "John Doe" -m "Added new features" my_container my_new_image
```

例：在不暂停容器的情况下，将其保存为新镜像。

```shell
docker commit --pause=false my_container my_new_image
```

### 实例
启动一个容器:

```shell
docker run -d -it --name my_container ubuntu bash
```

进行一些更改:

```shell
docker exec my_container apt-get update
docker exec my_container apt-get install -y nginx
```

提交容器为新镜像:

```shell
docker commit -a "Your Name" -m "Installed nginx" my_container my_new_image
```

查看新镜像:

```shell
docker images
```

### 常用场景
+ **保存工作进度**: 在开发或测试过程中，将容器的当前状态保存为镜像，以便稍后可以恢复。
+ **创建基础镜像**: 为特定应用程序或环境配置创建自定义基础镜像。
+ **分发配置**: 将特定配置或应用程序状态保存为镜像，以便分发给其他团队成员或在不同环境中使用。

`docker commit` 命令是一个强大的工具，允许用户将容器的当前状态保存为新的 Docker 镜像。通过使用该命令，用户可以创建自定义镜像，以便在将来重用或分发。添加适当的作者和提交信息，有助于跟踪镜像的历史和变化。