# Docker port 命令

[Docker命令大全](./docker-command-manual.md)

`docker port` 命令用于显示容器的端口映射信息，即容器内部的端口如何映射到宿主机的端口，对于了解容器如何与宿主机网络交互非常有用。

### 语法
docker port CONTAINER [PRIVATE_PORT[/PROTO]]

+ `CONTAINER`: 要查询端口映射的容器的名称或 ID。
+ `PRIVATE_PORT` (可选): 容器内部的端口号。
+ `PROTO` (可选): 协议类型（`tcp` 或 `udp`），默认是 `tcp`。

例：显示名为 my_container 的容器的所有端口映射信息。

```shell
docker port my_container
```

例：显示名为 my_container 的容器内部的端口 80 映射到宿主机的哪个端口。

```shell
docker port my_container 80
```

例：显示名为 my_container 的容器内部的 TCP 端口 80 映射到宿主机的哪个端口。

```shell
docker port my_container 80/tcp
```

### 实例
例：启动 my_container 容器并将端口 80 映射到宿主机的端口 8080。

```shell
docker run -d -p 8080:80 --name my_container nginx
```

例：查看容器的端口映射:

```shell
docker port my_container
```

输出：

```shell
80/tcp -> 0.0.0.0:8080
```

例：查看特定端口的映射

```shell
docker port my_container 80
```

输出：

```shell
0.0.0.0:8080
```

### 注意事项
+ `docker port` 命令仅显示端口映射信息，不会显示容器内部运行的服务的状态或其他信息。
+ 如果容器没有暴露任何端口，或者没有进行端口映射，`docker port` 命令将不会返回任何信息。

`docker port` 命令是一个用于查看容器端口映射的工具，帮助用户了解容器的端口如何映射到宿主机。通过使用这个命令，用户可以方便地检查和调试容器的网络配置。

