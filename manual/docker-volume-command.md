# Docker version 命令

[Docker命令大全](./docker-command-manual.md)

`docker volume` 命令用于管理 Docker 卷（volume）。卷是用于持久化数据的文件系统，可以在容器之间共享和重用。通过使用卷，数据可以在容器停止或删除时仍然保留。

### 常用 `docker volume` 命令
1. `**docker volume ls**`: 列出所有卷
2. `**docker volume inspect**`: 查看卷的详细信息
3. `**docker volume create**`: 创建一个新卷
4. `**docker volume rm**`: 删除一个或多个卷
5. `**docker volume prune**`: 删除未使用的卷

### `docker volume ls` 命令
列出所有卷。

```shell
docker volume ls
```

输出：

```shell
DRIVER              VOLUME NAME
local               my_volume
local               another_volume
```

### docker volume inspect 命令
查看指定卷的详细信息。

```shell
docker volume inspect my_volume
```

输出：

```shell
[
    {
        "CreatedAt": "2024-07-23T00:00:00Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my_volume/_data",
        "Name": "my_volume",
        "Options": {},
        "Scope": "local"
    }
]
```

### docker volume create 命令
创建一个新卷。

```shell
docker volume create my_volume
```

**常用参数**

+ `**--driver**`: 指定卷驱动程序（默认为 `local`）。
+ `**--label**`: 为卷添加标签。
+ `**-o, --opt**`: 为卷指定驱动程序选项。

示例：

```shell
docker volume create --name my_volume --label project=my_project
```

### docker volume rm 命令
删除一个或多个卷。

```shell
docker volume rm my_volume
```

删除多个卷：

```shell
docker volume rm volume1 volume2
```

### docker volume prune 命令
删除未使用的卷。

```shell
docker volume prune
```

### 使用场景
+ **持久化数据**: 卷用于持久化数据，即使容器被删除，数据仍然保留。
+ **共享数据**: 卷可以在多个容器之间共享数据。
+ **备份和恢复**: 卷可以用于备份和恢复容器数据。
+ **分离数据和应用**: 卷使数据和应用程序分离，便于管理和迁移。

`docker volume` 命令集提供了强大的数据管理功能，允许用户创建、配置和管理 Docker 卷。通过使用这些命令，用户可以实现数据的持久化、共享和备份，满足各种数据管理需求。

