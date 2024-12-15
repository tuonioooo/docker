# Docker ps 命令

[Docker命令大全](./docker-command-manual.md)

docker ps 命令用于列出 Docker 容器。

默认情况下，docker ps 命令**只显示运行中的容器**，但也可以通过指定选项来显示所有容器，包括停止的容器。

### 语法
docker ps [OPTIONS]

OPTIONS说明：

+ `**-a, --all**`: 显示所有容器，包括停止的容器。
+ `**-q, --quiet**`: 只显示容器 ID。
+ `**-l, --latest**`: 显示最近创建的一个容器，包括所有状态。
+ `**-n**`: 显示最近创建的 n 个容器，包括所有状态。
+ `**--no-trunc**`: 不截断输出。
+ `**-s, --size**`: 显示容器的大小。
+ `**--filter, -f**`: 根据条件过滤显示的容器。
+ `**--format**`: 格式化输出。

### 实例
**1、列出所有在运行的容器信息**

默认情况下，docker ps 只显示正在运行的容器。

```shell
docker ps
CONTAINER ID   IMAGE          COMMAND                ...  PORTS                    NAMES
09b93464c2f7   nginx:latest   "nginx -g 'daemon off" ...  80/tcp, 443/tcp          myrunoob
96f7f14e99ab   mysql:5.6      "docker-entrypoint.sh" ...  0.0.0.0:3306->3306/tcp   mymysql
```

输出详情介绍：

**CONTAINER ID:** 容器 ID。

**IMAGE:** 使用的镜像。

**COMMAND:** 启动容器时运行的命令。

**CREATED:** 容器的创建时间。

**STATUS:** 容器状态。

状态有7种：

+ created（已创建）
+ restarting（重启中）
+ running（运行中）
+ removing（迁移中）
+ paused（暂停）
+ exited（停止）
+ dead（死亡）

**PORTS:** 容器的端口信息和使用的连接类型（tcp\udp）。

**NAMES:** 自动分配的容器名称。

**2、显示所有容器，包括停止的容器**

```shell
docker ps -a
```

**3、只显示容器 ID**

```shell
docker ps -q
```

**4、显示最近创建的一个容器，包括所有状态。**

```shell
docker ps -l
```

**5、显示最近创建的 n 个容器**

**例：**显示最近创建的 3 个容器，包括所有状态。

```shell
docker ps -n 3
```

**6、显示容器的大小**

```shell
docker ps -s
```

**7、根据条件过滤显示的容器**

**例：**显示状态为 exited 的容器。

```shell
docker ps -f "status=exited"
```

例：显示名称包含 my_container 的容器。

```shell
docker ps -f "name=my_container"
```

**8、格式化输出**

例：以表格形式显示容器的 ID、名称和状态。

```shell
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
```

**9.关闭所有正在运行容器（****慎用****）**

```shell
docker ps | awk  '{print $1}' | xargs docker stop
```

**10. 删除所有容器应用****（****慎用****）**

```shell
docker ps -a | awk  '{print $1}' | xargs docker rm
```

### 常见过滤器
+ `**status**`: 容器状态（如 `running`、`paused`、`exited`）。
+ `**name**`: 容器名称。
+ `**id**`: 容器 ID。
+ `**label**`: 容器标签。
+ `**ancestor**`: 容器镜像。

### 使用场景
+ **监控容器状态**: 实时监控运行中的容器状态和资源使用情况。
+ **调试和管理**: 查看所有容器，包括停止的容器，以便进行调试和管理操作。
+ **自动化脚本**: 使用过滤器和格式化选项，便于在自动化脚本中获取特定容器信息。