# Docker start/stop/restart 命令

[Docker命令大全](./docker-command-manual.md)

---

**docker start** 命令用于启动一个或多个已经创建的容器。

**docker stop** 命令用于停止一个运行中的容器。

**docker restart** 命令用于重启容器。

---

## docker start 命令
### 语法
docker start [OPTIONS] CONTAINER [CONTAINER...]

**参数**

+ `-a`: 附加到容器的标准输入输出流。
+ `-i`: 附加并保持标准输入打开。

### 实例
启动一个容器:

```shell
docker start my_container
```

启动名称为 my_container 的容器。

启动并附加到容器:

```shell
docker start -a my_container
```

启动容器并附加到它的标准输入输出流，终端会显示容器的输出。

同时启动多个容器:

```shell
docker start container1 container2 container3
```

同时启动 container1、container2 和 container3 容器。

---

## docker stop 命令
### 语法
docker stop [OPTIONS] CONTAINER [CONTAINER...]

**参数**

**-t, --time**: 停止容器之前等待的秒数，默认是 10 秒。

### 实例
停止名称为 my_container 的容器。

```shell
docker stop my_container
```

等待 30 秒后停止容器。

```shell
docker stop -t 30 my_container
```

同时停止多个容器

例：同时停止 container1、container2 和 container3 容器。

```shell
docker stop container1 container2 container3
```

停止所有容器

```shell
docker stop $(docker ps -a -q)
```

---

## docker restart 命令
### 语法
docker restart [OPTIONS] CONTAINER [CONTAINER...]

**参数**

**-t, --time**: 重启容器之前等待的秒数，默认是 10 秒。

### 实例
重启一个容器:

```shell
docker restart my_container
```

重启名称为 my_container 的容器。

指定等待时间重启容器:

```shell
docker restart -t 15 my_container
```

等待 15 秒后重启容器。

同时重启多个容器:

```shell
docker restart container1 container2 container3
```

同时重启 container1、container2 和 container3 容器。