# Docker load 命令

[Docker命令大全](./docker-command-manual.md)

`docker load` 命令用于从由 `docker save` 命令生成的 tar 文件中加载 Docker 镜像。它可以将存档中的镜像和所有层加载到 Docker 中，使其可以在新环境中使用。

### 语法
docker load [OPTIONS]

OPTIONS 说明：

+ `**-i, --input**`: 指定输入文件的路径。
+ `**-q, --quiet**`: 安静模式，减少输出信息。

1、从文件加载镜像

```shell
docker load -i myimage.tar
```

这将从 myimage.tar 文件中加载镜像。

2、从标准输入加载镜像

```shell
cat myimage.tar | docker load
```

这将通过管道从标准输入加载镜像。

## 实例
**1、构建和保存镜像**

首先，构建一个示例镜像并保存，创建 Dockerfile：

```shell
# 使用 Ubuntu 作为基础镜像
FROM ubuntu:20.04

# 添加维护者信息
LABEL maintainer="yourname@example.com"

# 更新包列表并安装 Nginx
RUN apt-get update && apt-get install -y nginx

# 复制自定义网页到 Nginx 的默认网页目录
COPY index.html /var/www/html/

# 设置启动时的默认命令
CMD ["nginx", "-g", "daemon off;"]
```

构建镜像：

```shell
docker build -t mynginx:latest .
```

保存镜像到文件：

```shell
docker save -o mynginx.tar mynginx:latest
```

**2、加载镜像**

从文件加载镜像：

```shell
docker load -i mynginx.tar
```

**3、验证加载的镜像**

```shell
docker images
```

输出示例：

```shell
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mynginx             latest              123abc456def        1 minute ago        200MB
```

### 注意事项
+ 加载的镜像包括其所有层和元数据，与保存时的状态完全一致。
+ 使用 `docker load` 时，所有包含在 tar 文件中的镜像都会被加载。
+ 加载过程中可能需要较长时间，具体取决于镜像的大小和系统性能。

`docker load` 命令是从保存的 tar 文件中恢复 Docker 镜像的便捷方法。通过结合 `docker save` 和 `docker load`，用户可以轻松地在不同环境中备份、分发和迁移 Docker 镜像。

