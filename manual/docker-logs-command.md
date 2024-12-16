# Docker logs 命令

[Docker命令大全](./docker-command-manual.md)

`docker logs` 命令用于获取和查看容器的日志输出，可以帮助用户调试和监控运行中的容器。

### 语法
docker logs [OPTIONS] CONTAINER

常用选项：

+ `**-f, --follow**`: 跟随日志输出（类似于 `tail -f`）。
+ `**--since**`: 从指定时间开始显示日志。
+ `**-t, --timestamps**`: 显示日志时间戳。
+ `**--tail**`: 仅显示日志的最后部分，例如 `--tail 10` 显示最后 10 行。
+ `**--details**`: 显示提供给日志的额外详细信息。
+ `**--until**`: 显示直到指定时间的日志。

### 实例
**显示容器日志**

```shell
docker logs my_container
```

显示名为 my_container 的容器的所有日志，输出内容：

```shell
hello world
hello world
hello world
...
```

**跟随日志输出**

```shell
docker logs -f my_container
```

持续显示 my_container 的日志输出，输出内容：

```shell
hello world
hello world
hello world
...
```

**显示带时间戳的日志**

```shell
docker logs -t my_container
```

显示包含时间戳的日志，输出内容：

```shell
2023-07-22T15:04:05.123456789Z hello world
2023-07-22T15:04:06.123456789Z hello world
2023-07-22T15:04:07.123456789Z hello world
...
```

**从指定时间开始显示日志**

```shell
# 显示 2023-07-22T15:00:00 之后的日志。
docker logs --since="2023-07-22T15:00:00" my_container
```

**显示最后 10 行日志**

```shell
# 显示 my_container 的最后 10 行日志。
docker logs --tail 10 my_container
```

**显示额外详细信息的日志**

```shell
# 显示 my_container 的日志，并包含额外详细信息。
docker logs --details my_container
```

**显示直到指定时间的日志**

```shell
# 显示 2023-07-22T16:00:00 之前的日志。
docker logs --until="2023-07-22T16:00:00" my_container
```

