# Docker create 命令

[Docker命令大全](./docker-command-manual.md)

`docker create` 命令用于创建一个新的容器，但不会启动它。

`docker create` 命令会根据指定的镜像和参数创建一个容器实例，但容器只会在创建时进行初始化，并不会执行任何进程。

用法同 [docker run](https://www.runoob.com/docker/docker-run-command.html)。

### 语法
docker create [OPTIONS] IMAGE [COMMAND] [ARG...]

### 常用参数
+ `--name`: 给容器指定一个名称。
+ `-p, --publish`: 端口映射，格式为 `host_port:container_port`。
+ `-v, --volume`: 挂载卷，格式为 `host_dir:container_dir`。
+ `-e, --env`: 设置环境变量。
+ `--network`: 指定容器的网络模式。
+ `--restart`: 容器的重启策略（如 `no`、`on-failure`、`always`、`unless-stopped`）。
+ `-u, --user`: 指定用户。
+ `--entrypoint`: 覆盖容器的默认入口点。
+ `--detach`: 在后台创建容器。

### 实例
创建一个容器：

```shell
docker create ubuntu
```

根据 ubuntu 镜像创建一个容器，但不会启动它。

创建并指定容器名称：

```shell
docker create --name my_container ubuntu
```

创建一个名为 my_container 的容器，但不会启动它。

创建并设置环境变量：

```shell
docker create -e MY_ENV_VAR=my_value ubuntu
```

创建一个容器，并设置环境变量 MY_ENV_VAR 的值为 my_value。

创建并挂载卷：

```shell
docker create -v /host/data:/container/data ubuntu
```

创建一个容器，并将主机的 /host/data 目录挂载到容器的 /container/data 目录。

创建并端口映射：

```shell
docker create -p 8080:80 nginx
```

创建一个容器，将本地主机的 8080 端口映射到容器的 80 端口，但不会启动它。

创建并指定重启策略：

```shell
docker create --restart always nginx
```

创建一个容器，并将重启策略设置为 always。

创建并指定用户：

```shell
docker create -u user123 ubuntu
```

创建一个容器，并以 user123 用户运行容器。

### 查看容器
在创建容器之后，可以使用 docker ps -a 命令查看所有容器，包括已创建但未启动的容器。

```shell
docker ps -a
```

### 启动已创建的容器
使用 docker start 命令来启动已创建但未启动的容器：

```shell
docker start my_container
```

### 总结
+ `docker create`: 用于创建一个新的容器实例但不启动它。可以通过各种参数设置容器的配置。
+ `docker start`: 启动已创建的容器，使其开始运行。

:::color1
**友情提示：**

`docker create` 命令允许用户预先配置容器的设置，并在需要时手动启动容器，这对于自动化部署和测试场景特别有用。

:::