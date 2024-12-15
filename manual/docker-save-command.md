# Docker save 命令

[Docker命令大全](./docker-command-manual.md)

`docker save` 命令用于将一个或多个 Docker 镜像保存到一个 tar 归档文件中，以便在其他环境中分发或备份。

### 语法
docker save [OPTIONS] IMAGE [IMAGE...]

+ `**IMAGE**`: 要保存的一个或多个镜像名称或 ID。

OPTIONS 说明：

+ `**-o, --output**`: 指定输出文件的路径。

1、保存单个镜像到文件

```shell
docker save -o myimage.tar myimage:latest
```

这将 myimage:latest 镜像保存为 myimage.tar 文件。

2、保存多个镜像到同一个文件

```shell
docker save -o multiple_images.tar myimage:latest anotherimage:latest
```

这将 myimage:latest 和 anotherimage:latest 镜像保存到 multiple_images.tar 文件中。

## 实例
### 构建一个示例镜像
1、创建一个 Dockerfile：

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

2、保存镜像到文件

```shell
docker save -o mynginx.tar mynginx:latest
```

这将 mynginx:latest 镜像保存为 mynginx.tar 文件。

3、验证保存的文件

```shell
ls -lh mynginx.tar
```

输出示例：

```shell
-rw-r--r-- 1 user user 200M Jul 24 14:00 mynginx.tar
```

4、加载保存的镜像

要将保存的镜像加载到另一个 Docker 环境中，可以使用 docker load 命令：

```shell
docker load -i mynginx.tar
```

### 注意事项
+ 保存镜像时，会包含镜像的所有层，因此生成的 tar 文件可能会很大。
+ 如果保存多个镜像到同一个文件中，使用 `docker load` 命令时会加载所有包含的镜像。
+ 为了减少文件大小，可以在保存前使用 `docker image prune` 命令清理未使用的镜像和层。

`docker save` 命令是一个方便的工具，用于将 Docker 镜像保存为 tar 文件，以便于备份、分发和迁移。通过结合 `docker load` 命令，可以轻松地在不同环境中恢复和使用保存的镜像。

