# Docker stats 命令

[Docker命令大全](./docker-command-manual.md)

`docker stats` 

命令用于实时显示 Docker 容器的资源使用情况，包括 CPU、内存、网络 I/O 和块 I/O。

类似于 Linux 系统中的 `top` 命令，但它专门针对 Docker 容器。通过 `docker stats`，用户可以监控容器的资源使用情况，帮助优化性能和进行故障排除。

### 语法
docker stats [OPTIONS] [CONTAINER...]

OPTIONS 说明：

+ **--all , -a :**显示所有的容器，包括未运行的。
+ **--format :**指定返回值的模板文件。
+ **--no-stream :**展示当前状态就直接退出了，不再实时更新。
+ **--no-trunc :**不截断输出。

显示所有运行的容器的资源使用情况:

```shell
docker stats
```

显示指定容器的资源使用情况:

```shell
docker stats my_container
```

显示所有容器（包括未运行的容器）的资源使用情况:

```shell
docker stats --all
```

只显示一次数据而不是持续刷新:

```shell
docker stats --no-stream
```

使用自定义格式输出:

```shell
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

### 实例
列出所有在运行的容器信息。

```shell
$  docker stats
CONTAINER ID        NAME                                    CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
b95a83497c91        awesome_brattain                        0.28%               5.629MiB / 1.952GiB   0.28%               916B / 0B           147kB / 0B          9
67b2525d8ad1        foobar                                  0.00%               1.727MiB / 1.952GiB   0.09%               2.48kB / 0B         4.11MB / 0B         2
e5c383697914        test-1951.1.kay7x1lh1twk9c0oig50sd5tr   0.00%               196KiB / 1.952GiB     0.01%               71.2kB / 0B         770kB / 0B          1
4bda148efbc0        random.1.vnc8on831idyr42slu578u3cr      0.00%               1.672MiB / 1.952GiB   0.08%               110kB / 0B          578kB / 0B          2
```

输出详情介绍：

**CONTAINER ID 与 NAME:** 容器 ID 与名称。

**CPU % 与 MEM %:** 容器使用的 CPU 和内存的百分比。

**MEM USAGE / LIMIT:** 容器正在使用的总内存，以及允许使用的内存总量。

**NET I/O:** 容器通过其网络接口发送和接收的数据量。

**BLOCK I/O:** 容器从主机上的块设备读取和写入的数据量。

**PIDs:** 容器创建的进程或线程数。

根据容器等 ID 或名称现实信息：

```shell
docker stats awesome_brattain 67b2525d8ad1

CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
b95a83497c91        awesome_brattain    0.28%               5.629MiB / 1.952GiB   0.28%               916B / 0B           147kB / 0B          9
67b2525d8ad1        foobar              0.00%               1.727MiB / 1.952GiB   0.09%               2.48kB / 0B         4.11MB / 0B         2
```

以 JSON 格式输出：

```shell
docker stats nginx --no-stream --format "{{ json . }}"
  {"BlockIO":"0B / 13.3kB","CPUPerc":"0.03%","Container":"nginx","ID":"ed37317fbf42","MemPerc":"0.24%","MemUsage":"2.352MiB / 982.5MiB","Name":"nginx","NetIO":"539kB / 606kB","PIDs":"2"}
```

输出指定的信息：

```shell
docker stats --all --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" fervent_panini 5acfcb1b4fd1 drunk_visvesvaraya big_heisenberg
  {"BlockIO":"0B / 13.3kB","CPUPerc":"0.03%","Container":"nginx","ID":"ed37317fbf42","MemPerc":"0.24%","MemUsage":"2.352MiB / 982.5MiB","Name":"nginx","NetIO":"539kB / 606kB","PIDs":"2"}

CONTAINER                CPU %               MEM USAGE / LIMIT
fervent_panini           0.00%               56KiB / 15.57GiB
5acfcb1b4fd1             0.07%               32.86MiB / 15.57GiB
drunk_visvesvaraya       0.00%               0B / 0B
big_heisenberg           0.00%               0B / 0B
```

### 常用场景
+ **实时监控**: 实时查看容器的资源使用情况，以便进行性能监控和优化。
+ **故障排除**: 在容器出现问题时，检查资源使用情况，帮助排查问题根源。
+ **资源管理**: 监控容器的资源使用情况，确保资源分配合理，避免资源浪费或瓶颈。

`docker stats` 命令是一个强大的工具，用于实时监控 Docker 容器的资源使用情况。通过该命令，用户可以获取容器的 CPU、内存、网络 I/O 和块 I/O 的详细信息，帮助进行性能优化、故障排除和资源管理。