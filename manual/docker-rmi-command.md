# Docker rm 命令

[Docker命令大全](./docker-command-manual.md)

`docker rmi` 

命令用于删除一个或多个 Docker 镜像，对于管理本地存储的镜像非常有用，帮助用户清理不再需要的镜像，释放存储空间。

### 语法
docker rmi [OPTIONS] IMAGE [IMAGE...]

**参数说明：**

+ `IMAGE`: 要删除的镜像的名称或 ID。可以是镜像名、镜像 ID 或镜像摘要。
+ `OPTIONS`: 可选参数，用来控制命令的行为。

常用选项：

+ `-a`, `--all-tags`: 指定仓库名称时，删除该仓库下的所有镜像。
+ `-f`, `--force`: 强制删除镜像，即使该镜像被容器使用。
+ `--help`: 打印帮助信息并退出。
+ `--no-prune`: 不删除悬空的父镜像。
+ `-q`, `--quiet`: 安静模式，不显示删除镜像的详细信息。

**删除单个镜像**

**例：**删除名为 ubuntu 的 latest 标签的镜像。

```shell
docker rmi ubuntu:latest
```

**删除多个镜像**

例：删除 ubuntu 和 nginx 的 latest 标签的镜像。

```shell
docker rmi ubuntu:latest nginx:latest
```

**删除镜像的多个标签**

**例：**删除 ubuntu 镜像的 latest 和 18.04 标签。

```shell
docker rmi ubuntu:latest ubuntu:18.04
```

**删除所有标签的镜像**

**例：**删除 ubuntu 仓库下的所有镜像。

```shell
docker rmi -a ubuntu
```

**强制删除镜像**

**例：**强制删除 ubuntu 的 latest 标签的镜像，即使它正在被使用。

```shell
docker rmi -f ubuntu:latest
```

**删除悬空的镜像**

**例：**删除所有没有标签的悬空镜像。

```shell
docker rmi -d
```

**安静模式删除所有镜像**

**例：**使用安静模式删除所有镜像，不显示删除的镜像信息。

```shell
docker rmi -q $(docker images -q)
```

**删除指定仓库的所有镜像**

**例：**删除 myrepo 仓库下的所有镜像。

```shell
docker rmi -a myrepo
```

**删除镜像并保留其子镜像**

**例：**删除 ubuntu:latest 镜像，但保留其子镜像。

```shell
docker rmi --no-prune ubuntu:latest
```

**想要删除untagged images，也就是那些id为<None>的image的话可以用**

```shell
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
```

### 实例
查看现有镜像：

```shell
docker images
```

输出：

```shell
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
my_image            latest              d1e1b5a3a8a9        3 days ago          128MB
my_image1           latest              c3a4f5a3a8b8        4 days ago          256MB
my_image2           latest              a9e1d3a7c9b9        5 days ago          512MB
```

删除一个镜像：

```shell
docker rmi my_image
```

输出：

```shell
Untagged: my_image:latest
Deleted: sha256:d1e1b5a3a8a9...
```

删除多个镜像：

```shell
docker rmi my_image1 my_image2
```

输出：

```shell
Untagged: my_image1:latest
Deleted: sha256:c3a4f5a3a8b8...
Untagged: my_image2:latest
Deleted: sha256:a9e1d3a7c9b9...
```

删除全部镜像（**慎用**）

```shell
docker rmi $(docker images -q)
```

### 常用场景
+ **清理无用镜像**: 删除不再需要的镜像，以释放存储空间。
+ **镜像管理**: 管理和维护本地镜像库，确保只保留需要的镜像。
+ **强制删除**: 在镜像被容器使用时，强制删除它们（谨慎使用）。

### 注意事项
+ 强制删除镜像（使用 `-f` 选项）时，可能会导致依赖于该镜像的容器无法运行，因此应谨慎使用。
+ 默认情况下，`docker rmi` 会删除未使用的父镜像，如果不希望这样做，可以使用 `--no-prune` 选项。

`docker rmi` 命令是 Docker 镜像管理中非常重要的工具。通过该命令，用户可以删除不再需要的镜像，释放存储空间，并保持本地镜像库的整洁。使用适当的选项，可以灵活地管理镜像的删除过程。

