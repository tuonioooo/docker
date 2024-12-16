# Docker rm 命令

[Docker命令大全](./docker-command-manual.md)

docker rm 命令用于删除一个或多个已经停止的容器。

docker rm 命令不会删除正在运行的容器，如果你需要先停止容器，可以使用 docker stop 命令。

### 语法
docker rm [OPTIONS] CONTAINER [CONTAINER...]

+ `CONTAINER [CONTAINER...]`: 一个或多个要删除的容器的名称或 ID。

OPTIONS说明：

+ `-f`, `--force`: 强制删除正在运行的容器（使用 `SIGKILL` 信号）。
+ `-l`, `--link`: 删除指定的连接，而不是容器本身。
+ `-v`, `--volumes`: 删除容器挂载的卷。

删除单个容器：

```shell
docker rm <container_id_or_name>
```

你可以一次性删除多个容器，只需将容器 ID 或名称用空格分隔：

```shell
docker rm <container_id_or_name1> <container_id_or_name2> ...
```

你可以使用以下命令来删除所有已停止的容器（慎用）：

```shell
#是一个清理命令，用于删除所有处于已停止状态的容器，从而释放系统资源和存储空间。
docker container prune 
```

### 实例
假设你有以下两个容器：

```shell
CONTAINER ID        IMAGE          COMMAND             CREATED             STATUS              PORTS      NAMES
abcd1234            nginx         "nginx -g 'daemon…" 2 minutes ago       Exited (0) 1 minute ago        my_nginx
efgh5678            redis         "redis-server"      3 minutes ago       Exited (0) 2 minutes ago       my_redis
```

你可以使用以下命令删除它们：

```shell
docker rm abcd1234 efgh5678
```

或者，你可以使用容器名称删除它们：

```shell
docker rm my_nginx my_redis
```

删除所有已经停止的容器（**慎用**）：

```shell
docker rm $(docker ps -a -q)
```

用完立即从容器删除

```shell
docker run -it --rm -p 8080:8080 tomcat:9.0
```

> 说明：
>
> + 运行一个基于 `tomcat:9.0` 镜像的容器。
> + 容器启动时提供交互式终端。
> + 容器停止时自动删除，不会在系统中保留。