# Docker kill 命令

[Docker命令大全](./docker-command-manual.md)

docker kill 命令用于立即终止一个或多个正在运行的容器。

> [!CAUTION]
>
> `docker kill` 命令用于立即终止一个或多个正在运行的容器，通过发送信号（默认 SIGKILL）给容器的主进程实现。与 `docker stop` 不同，`docker kill` 不会等待容器优雅地停止，而是直接终止进程。该命令在需要快速停止容器时非常有用，但应谨慎使用以避免数据损失或不一致。

### 语法
docker kill [OPTIONS] CONTAINER [CONTAINER...]

OPTIONS说明：

+ `-s, --signal`: 发送给容器的信号（默认为 SIGKILL）。

**常用信号**

+ **SIGKILL**: 强制终止进程（默认信号）。
+ **SIGTERM**: 请求进程终止。
+ **SIGINT**: 发送中断信号，通常表示用户请求终止。
+ **SIGHUP**: 挂起信号，通常表示终端断开。

### 实例
立即终止一个容器:

```shell
docker kill my_container
```

立即终止名称为 my_container 的容器。

发送自定义信号:

```shell
docker kill -s SIGTERM my_container
```

向名称为 my_container 的容器发送 SIGTERM 信号，而不是默认的 SIGKILL 信号。

同时终止多个容器:

```shell
docker kill container1 container2 container3
```

立即终止 container1、container2 和 container3 容器。