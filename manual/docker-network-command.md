# Docker network 命令

[Docker命令大全](./docker-command-manual.md)

`docker network` 命令用于管理 Docker 网络。这些命令可以创建、列出、删除和检查网络，帮助用户在 Docker 容器之间建立通信。

### 常用 `docker network` 命令
1. `**docker network ls**`: 列出所有网络
2. `**docker network inspect**`: 查看网络详细信息
3. `**docker network create**`: 创建一个新网络
4. `**docker network rm**`: 删除一个或多个网络
5. `**docker network connect**`: 将一个容器连接到一个网络
6. `**docker network disconnect**`: 将一个容器从一个网络断开

### `docker network ls` 命令
列出所有网络。

```shell
docker network ls
```

输出：

```shell
NETWORK ID          NAME                DRIVER              SCOPE
b649b57f5bc5        bridge              bridge              local
7e8c2d2c0b5a        host                host                local
6a9c8d69bfb2        none                null                local
```

### `docker network inspect` 命令
查看指定网络的详细信息。

输出：

```shell
[
    {
        "Name": "my_network",
        "Id": "b649b57f5bc5",
        "Created": "2024-07-23T00:00:00.000000000Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

### `docker network create` 命令
创建一个新网络。

```shell
docker network create my_network
```

**常用参数**

+ `**--driver**`: 指定网络驱动程序（如 `bridge`、`host`、`overlay`）。
+ `**--subnet**`: 指定子网。
+ `**--gateway**`: 指定网关。
+ `**--ip-range**`: 指定可用 IP 地址范围。
+ `**--ipv6**`: 启用 IPv6。
+ `**--label**`: 为网络添加标签。

示例：

```shell
docker network create --driver bridge --subnet 192.168.1.0/24 my_network
```

### `docker network rm` 命令
删除一个或多个网络。

```shell
docker network rm my_network
```

删除多个网络：

```shell
docker network rm network1 network2
```

### `docker network connect` 命令
将一个容器连接到一个网络。

```shell
docker network connect my_network my_container
```

创建mysql容器并加入到 my_network 网络

```shell
docker run -p 3367:3306 \
--name mysql02 \
-e MYSQL_ROOT_PASSWORD=123456 \
-v /home/mysql02/data:/var/lib/mysql \
--net my_network \
-d mysql
```

### `docker network disconnect` 命令
将一个容器从一个网络断开。

```shell
docker network disconnect my_network my_container
```

### 使用场景
+ **容器间通信**: 通过自定义网络，容器可以在不同主机上安全地相互通信。
+ **隔离环境**: 使用不同的网络来隔离容器环境，提高安全性。
+ **高级网络配置**: 使用桥接、覆盖等网络驱动程序实现复杂的网络拓扑结构。

`docker network` 命令集提供了强大的网络管理功能，允许用户创建、配置和管理 Docker 容器之间的网络连接。通过使用这些命令，用户可以实现容器之间的隔离、通信和网络配置，满足各种复杂的网络需求。

