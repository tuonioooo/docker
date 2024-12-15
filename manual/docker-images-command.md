# Docker images 命令

[Docker命令大全](./docker-command-manual.md)

`docker images` 

命令用于列出本地的 Docker 镜像。

通过 `docker images` 命令，用户可以查看所有已下载或构建的 Docker 镜像的详细信息，如仓库名称、标签、镜像 ID、创建时间和大小。

下载镜像默认保存在** ****/var/lib/docker**** **目录下

### 语法
docker images [OPTIONS] [REPOSITORY[:TAG]]

OPTIONS 说明：

+ `**-a, --all**`: 显示所有镜像（包括中间层镜像）。
+ `**--digests**`: 显示镜像的摘要信息。
+ `**-f, --filter**`: 过滤输出，基于提供的条件。
+ `**--format**`: 使用 Go 模板格式化输出。
+ `**--no-trunc**`: 显示完整的镜像 ID。
+ `**-q, --quiet**`: 只显示镜像 ID。

列出所有本地镜像:

```shell
docker images
```

列出带有摘要信息的镜像:

```shell
docker images --digests
```

列出所有镜像（包括中间层镜像）:

```shell
docker images --all
```

使用过滤条件列出镜像:

```shell
docker images --filter "dangling=true"
```

只显示镜像 ID:

```shell
docker images --quiet
```

使用自定义格式输出:

```shell
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
```

### 实例
查看本地镜像列表:

```shell
tuonioooo@ecs:~$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
mymysql                 v1                  37af1236adef        5 minutes ago       329 MB
runoob/ubuntu           v4                  1c06aa18edee        2 days ago          142.1 MB
<none>                  <none>              5c6e1090e771        2 days ago          165.9 MB
httpd                   latest              ed38aaffef30        11 days ago         195.1 MB
alpine                  latest              4e38e38c8ce0        2 weeks ago         4.799 MB
mongo                   3.2                 282fd552add6        3 weeks ago         336.1 MB
redis                   latest              4465e4bcad80        3 weeks ago         185.7 MB
php                     5.6-fpm             025041cd3aa5        3 weeks ago         456.3 MB
python                  3.5                 045767ddf24a        3 weeks ago         684.1 MB
...
```

列出本地镜像中 REPOSITORY 为 ubuntu的 镜像列表:

```shell
root@runoob:~# docker images  ubuntu
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              14.04               90d5884b1ee0        9 weeks ago         188 MB
ubuntu              15.10               4e3b13c8a266        3 months ago        136.3 MB
```

带有摘要信息的输出:

```shell
docker images --digests
```

输出：

```shell
REPOSITORY          TAG                 DIGEST                                                                    IMAGE ID            CREATED             SIZE
ubuntu              latest              sha256:8c53f09a9c6f1e85e10a8ffb649dd9de28b9be4994e792bd96fca152527bba03   2d13d07a40a3        2 weeks ago         72.9MB
nginx               stable              sha256:1c4f40db5d1c8e5e09d28e501ad167d7c2d91b8908f6f1d9c97d1c67c5f9a69b   5a34e9e5d33b        3 weeks ago         133MB
hello-world         latest              sha256:feda4427b0b5d9d84545dcb38e736a5226e5bb6228c61b0b6b28cb7483a14b68   feb5d9fea6a5        4 weeks ago         13.3kB
```

使用过滤条件输出:

```shell
docker images --filter "dangling=true"
```

示例输出：

```shell
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              7db03500db4f        5 weeks ago         65.3MB
```

自定义格式输出:

```shell
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
```

输出：

```shell
REPOSITORY          TAG                 IMAGE ID            SIZE
ubuntu              latest              2d13d07a40a3        72.9MB
nginx               stable              5a34e9e5d33b        133MB
hello-world         latest              feb5d9fea6a5        13.3kB
```

### 常用场景
+ **管理镜像**: 列出本地镜像，了解当前可用的镜像。
+ **过滤镜像**: 使用过滤选项查找特定条件的镜像，如悬空镜像（未打标签的镜像）。
+ **镜像 ID 管理**: 只获取镜像 ID 以便于后续操作，如删除镜像。

`docker images` 命令是 Docker 镜像管理中非常基础且重要的命令。通过该命令，用户可以查看本地所有镜像的详细信息，进行镜像的管理和维护。使用各种选项和格式，可以灵活地过滤和格式化输出，以满足不同的管理需求。

