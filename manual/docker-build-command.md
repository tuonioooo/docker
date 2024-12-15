# Docker build 命令

[Docker命令大全](./docker-command-manual.md)

`docker build` 

命令用于从 Dockerfile 构建 Docker 镜像，通过读取 Dockerfile 中定义的指令，逐步构建镜像，并将最终结果保存到本地镜像库中。

### 语法

docker build [OPTIONS] PATH | URL | -

+ `**PATH**`: 包含 Dockerfile 的目录路径或 `.`（当前目录）。
+ `**URL**`: 指向包含 Dockerfile 的远程存储库地址（如 Git 仓库）。
+ `**-**`: 从标准输入读取 Dockerfile。

常用选项：

+ `**-t, --tag**`: 为构建的镜像指定名称和标签。
+ `**-f, --file**`: 指定 Dockerfile 的路径（默认是 `PATH` 下的 `Dockerfile`）。
+ `**--build-arg**`: 设置构建参数。
+ `**--no-cache**`: 不使用缓存层构建镜像。
+ `**--rm**`: 构建成功后删除中间容器（默认开启）。
+ `**--force-rm**`: 无论构建成功与否，一律删除中间容器。
+ `**--pull**`: 始终尝试从注册表拉取最新的基础镜像。

更多选项说明：

+ `**--build-arg=[]**`: 设置构建镜像时的变量。
+ `**--cpu-shares**`: 设置 CPU 使用权重。
+ `**--cpu-period**`: 限制 CPU CFS 周期。
+ `**--cpu-quota**`: 限制 CPU CFS 配额。
+ `**--cpuset-cpus**`: 指定可使用的 CPU ID。
+ `**--cpuset-mems**`: 指定可使用的内存节点 ID。
+ `**--disable-content-trust**`: 忽略内容信任验证（默认启用）。
+ `**-f**`: 指定 Dockerfile 的路径。
+ `**--force-rm**`: 强制在构建过程中删除中间容器。
+ `**--isolation**`: 使用指定的容器隔离技术。
+ `**--label=[]**`: 设置镜像的元数据。
+ `**-m**`: 设置内存的最大值。
+ `**--memory-swap**`: 设置交换空间的最大值（内存 + 交换空间），`-1` 表示不限制交换空间。
+ `**--no-cache**`: 构建镜像时不使用缓存。
+ `**--pull**`: 尝试拉取基础镜像的最新版本。
+ `**--quiet, -q**`: 安静模式，构建成功后只输出镜像 ID。
+ `**--rm**`: 构建成功后删除中间容器（默认启用）。
+ `**--shm-size**`: 设置 `/dev/shm` 的大小，默认值为 64M。
+ `**--ulimit**`: 设置 Ulimit 配置。
+ `**--squash**`: 将 Dockerfile 中所有步骤压缩为一层。
+ `**--tag, -t**`: 为镜像指定名称和标签，格式为 `name:tag` 或 `name`；可以在一次构建中为一个镜像设置多个标签。
+ `**--network**`: 在构建期间设置 `RUN` 指令的网络模式，默认值为 `default`。

**1、构建镜像**

```shell
docker build -t myimage:latest .
```

这会从当前目录读取 Dockerfile 并构建一个名为 myimage:latest 的镜像。

**2、指定 Dockerfile 路径**

```shell
docker build -f /path/to/Dockerfile -t myimage:latest .
```

这会从 /path/to/ 目录读取 Dockerfile 并构建一个名为 myimage:latest 的镜像。

**3、设置构建参数**

```shell
docker build --build-arg HTTP_PROXY=http://proxy.example.com -t myimage:latest .
```

这会在构建过程中使用 HTTP_PROXY 环境变量。

**4、不使用缓存层构建镜像**

```shell
docker build --no-cache -t myimage:latest .
```

这会在构建镜像时忽略所有缓存层，确保每一步都重新执行。

### 实例 - 使用 Dockerfile 构建镜像

1、创建 Dockerfile，内容如下：

```shell
# Dockerfile 示例
FROM ubuntu:20.04
LABEL maintainer="yourname@example.com"
RUN apt-get update && apt-get install -y nginx
COPY index.html /var/www/html/index.html
CMD ["nginx", "-g", "daemon off;"]
```

2、构建镜像

```shell
docker build -t mynginx:latest .
```

输出示例：

```shell
Sending build context to Docker daemon  3.072kB
Step 1/5 : FROM ubuntu:20.04
20.04: Pulling from library/ubuntu
...
Step 2/5 : LABEL maintainer="yourname@example.com"
...
Step 3/5 : RUN apt-get update && apt-get install -y nginx
...
Step 4/5 : COPY index.html /var/www/html/index.html
...
Step 5/5 : CMD ["nginx", "-g", "daemon off;"]
...
Successfully built 123456789abc
Successfully tagged mynginx:latest
```

3、验证镜像

```shell
docker images
```

输出示例：

### 注意事项

```shell
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
mynginx      latest    123456789abc   10 minutes ago   200MB
```

+ 确保 Dockerfile 语法正确，并按照顺序执行每一步。
+ 使用 `.dockerignore` 文件排除不需要的文件和目录，以减少构建上下文的大小。
+ 在生产环境中，尽量使用精简的基础镜像以减小镜像体积和提高安全性。
+ 避免在 Dockerfile 中暴露敏感信息（如密码、密钥）。

`docker build` 命令是构建 Docker 镜像的核心工具，通过定义清晰的 Dockerfile，可以自动化地构建应用程序的运行环境和依赖。在使用时，确保合理设置选项和优化 Dockerfile，以提高构建效率和镜像质量。

### 高级进阶

[Dockerfile构建Spring Boot应用镜像](../advanced/docker-dockerfile-springboot-advanced.md)

