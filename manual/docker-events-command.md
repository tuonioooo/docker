# Docker rm 命令

[Docker命令大全](./docker-command-manual.md)

`docker events` 命令用于实时获取 Docker 守护进程生成的事件，允许用户监控 Docker 容器、镜像、网络和卷的各种操作事件，例如创建、启动、停止、删除等。

### 语法
docker events [OPTIONS]

OPTIONS说明：

+ `**-f, --filter**`: 根据提供的条件过滤输出。
+ `**--format**`: 使用 Go 模板格式化输出。
+ `**--since**`: 显示从指定时间开始的事件。
+ `**--until**`: 显示直到指定时间的事件。

### 实例
获取所有事件：

```shell
docker events
```

输出：

```shell
2023-07-22T15:04:05.123456789Z container create 123abc456def (image=ubuntu, name=my_container)
2023-07-22T15:04:06.123456789Z container start 123abc456def (image=ubuntu, name=my_container)
2023-07-22T15:04:10.123456789Z container stop 123abc456def (image=ubuntu, name=my_container)
2023-07-22T15:04:11.123456789Z container destroy 123abc456def (image=ubuntu, name=my_container)
```

过滤事件：

```shell
docker events --filter event=stop
```

以上命令只显示容器停止事件。

输出：

```shell
2023-07-22T15:04:10.123456789Z container stop 123abc456def (image=ubuntu, name=my_container)
```

格式化输出：

```shell
docker events --format '{{.Time}} - {{.Type}} - {{.Action}}'
```

以上命令使用指定格式显示事件。

输出：

```shell
2023-07-22T15:04:05.123456789Z - container - create
2023-07-22T15:04:06.123456789Z - container - start
2023-07-22T15:04:10.123456789Z - container - stop
2023-07-22T15:04:11.123456789Z - container - destroy
```

显示从指定时间开始的事件：

```shell
docker events --since "2023-07-22T15:04:05"
```

以上命令显示从 2023-07-22T15:04:05 开始的事件。

显示直到指定时间的事件：

```shell
docker events --until "2023-07-22T16:04:05"
```

以上命令显示直到 2023-07-22T16:04:05 的事件。