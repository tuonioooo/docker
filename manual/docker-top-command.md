# Docker top 命令

[Docker命令大全](./docker-command-manual.md)

`docker top`

命令用于显示指定容器中的正在运行的进程，类似于 Linux 中的 `top` 或 `ps` 命令，它帮助用户查看容器内的进程信息，便于监控和调试容器内的活动。

### 语法
docker top [OPTIONS] CONTAINER [ps OPTIONS]

**查看容器内的进程:**

```shell
docker top my_container
```

这将显示容器 my_container 中所有正在运行的进程。

**使用自定义 ps 选项:**

```shell
docker top my_container -o pid,comm
```

这将显示容器 my_container 中所有正在运行的进程，并只显示 pid 和 comm 列。

### 实例
查看容器内的进程：

```shell
docker top my_container
```

示例输出：

```shell
UID       PID        PPID      C      STIME    TTY        TIME          CMD
root      1725       1708      0      14:02    ?          00:00:00      bash
root      1767       1725      0      14:03    ?          00:00:00      ps
```

自定义输出：

```shell
docker top my_container -o pid,comm
```

示例输出：

```shell
PID                 COMMAND
1725                bash
1767                ps
```

### 常用场景
+ **监控容器内部活动**: 通过查看容器内的进程，用户可以监控容器内部正在运行的应用程序和服务。
+ **调试和排查问题**: 当容器出现问题时，可以通过 `docker top` 命令查看容器内的进程，帮助排查问题。
+ **资源管理**: 了解容器内的进程和资源使用情况，便于进行资源管理和优化。

`docker top` 命令是一个有用的工具，帮助用户查看容器内正在运行的进程信息。通过该命令，用户可以监控、调试和管理容器内的活动，确保容器正常运行。</font>

