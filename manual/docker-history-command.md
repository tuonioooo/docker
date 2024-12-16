# Docker history 命令

[Docker命令大全](./docker-command-manual.md)

`docker history` 命令用于查看指定镜像的历史层信息，它显示了镜像创建过程中的每一层，包括创建时间、创建者、大小和注释等信息。

### 语法

docker history [OPTIONS] IMAGE

+ `**IMAGE**`: 要查看历史记录的镜像名称或 ID。

OPTIONS 说明：

+ `**-H, --human**`: 以人类可读的格式显示镜像大小（默认启用）。
+ `**--no-trunc**`: 显示完整的输出，不截断信息。
+ `**-q, --quiet**`: 仅显示镜像 ID。

## 实例

**1、查看镜像历史**

```shell
docker history myimage:latest
```

输出示例：

```shell
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
sha256:123abc456def 2 days ago          /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
sha256:789ghi012jkl 2 days ago          /bin/sh -c #(nop)  COPY file:abc123 in /var/…   1.5kB
sha256:345mno678pqr 2 days ago          /bin/sh -c apt-get update && apt-get install…   45.3MB
sha256:678stu901vwx 2 days ago          /bin/sh -c #(nop)  LABEL maintainer=yourname…   0B
sha256:901yza234bcd 2 days ago          /bin/sh -c #(nop)  FROM ubuntu:20.04           72.9MB
```

**2、显示完整输出**

```shell
docker history --no-trunc myimage:latest
```

**3、仅显示镜像 ID**

```shell
docker history -q myimage:latest
```

输出示例：

```shell
sha256:123abc456def
sha256:789ghi012jkl
sha256:345mno678pqr
sha256:678stu901vwx
sha256:901yza234bcd
```

### 操作实例

**构建一个简单的镜像**

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

2、构建镜像：

```shell
docker build -t mynginx:latest .
```

3、查看镜像历史

```shell
docker history mynginx:latest
```

输出示例：

```shell
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
sha256:123abc456def 1 minute ago        /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
sha256:789ghi012jkl 1 minute ago        /bin/sh -c #(nop)  COPY file:abc123 in /var/…   1.5kB
sha256:345mno678pqr 1 minute ago        /bin/sh -c apt-get update && apt-get install…   45.3MB
sha256:678stu901vwx 1 minute ago        /bin/sh -c #(nop)  LABEL maintainer=yourname…   0B
sha256:901yza234bcd 1 minute ago        /bin/sh -c #(nop)  FROM ubuntu:20.04
```

### 注意事项

+ 镜像历史信息包括每一层的创建指令和大小，有助于了解镜像的构建过程和内容。
+ 使用 `--no-trunc` 选项可以查看完整的创建指令，避免信息截断。
+ 在构建复杂镜像时，通过查看历史记录，可以帮助识别和优化 Dockerfile 中的冗余步骤。

`docker history` 命令是一个强大的工具，可以帮助开发者和运维人员了解镜像的构建历史和每一层的详细信息。通过查看镜像历史，可以更好地调试、优化和审计 Docker 镜像，确保镜像的高效和安全。

