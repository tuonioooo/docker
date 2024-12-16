# Docker wait 命令

[Docker命令大全](./docker-command-manual.md)

`docker wait` 命令用于阻塞，直到指定的容器停止运行，然后返回容器的退出代码，对于自动化脚本非常有用，因为它可以等待容器完成某项任务，并根据容器的退出状态采取后续操作。

### 语法
docker wait [OPTIONS] CONTAINER [CONTAINER...]

等待一个容器停止并获取其退出代码:

```shell
docker wait my_container
```

等待多个容器停止并获取它们的退出代码:

```shell
docker wait container1 container2
```

### 实例
启动一个会立即退出的容器:

```shell
docker run --name test_container ubuntu bash -c "exit 5"
```

使用 docker wait 命令等待容器退出并获取退出代码:

```shell
# 此命令等待 test_container 退出，并返回退出代码 5。
docker wait test_container
```

输出：

```shell
5
```

启动多个会立即退出的容器:

```shell
docker run --name test_container1 ubuntu bash -c "exit 1"
docker run --name test_container2 ubuntu bash -c "exit 2"
```

使用 docker wait 命令等待多个容器退出并获取它们的退出代码:

```shell
# 此命令等待 test_container1 和 test_container2 退出，并返回它们的退出代码 1 和 2。
docker wait test_container1 test_container2
```

输出：

```shell
1
2
```

### **注意事项**
+ `docker wait` 命令会阻塞直到容器停止，因此在长时间运行的容器上使用时需要注意。
+ 该命令仅返回容器的退出代码，不提供其他关于容器的状态或输出的信息。

`docker wait` 命令是一个简单但非常有用的工具，允许用户等待容器停止并获取其退出代码。通过该命令，用户可以轻松地在脚本中实现任务同步和自动化操作。使用 `docker wait` 命令，可以确保在指定的容器完成其任务之前，不会进行任何后续操作。

