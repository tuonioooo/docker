# Docker inspect 查看容器、镜像的高级用法

## 1. 查看完整的挂载信息

```bash
# 查看完整的挂载信息（JSON 格式）
docker inspect mysql --format='{{json .Mounts}}' | jq .

# 如果没有 jq，使用原生输出，只查看挂载部分
docker inspect mysql | grep -A 30 '"Mounts"'
```

### jq 命令安装

| 系统类型          | 安装命令                                                     |
| ----------------- | ------------------------------------------------------------ |
| **Ubuntu/Debian** | `sudo apt-get update && sudo apt-get install -y jq`          |
| **CentOS/RHEL**   | `sudo yum install -y epel-release && sudo yum install -y jq` |
| **Alpine**        | `apk add jq`                                                 |
| **Arch Linux**    | `pacman -S jq`                                               |
| **macOS**         | `brew install jq`                                            |
| **Windows**       | 从 [jq 官网](https://stedolan.github.io/jq/download/) 下载二进制文件 |


## 2. 查看 Binds 和 Mounts 信息

```bash
# 查看 HostConfig 中的 Binds
docker inspect mysql --format='{{json .HostConfig.Binds}}'

# 查看 Bind mount
docker container inspect mysql --format='{{range .Mounts}}{{if eq .Type "bind"}}Bind: {{.Source}} -> {{.Destination}}{{end}}{{end}}'

# 查看 Mounts 信息（推荐）
docker inspect mysql --format='{{json .Mounts}}'
```

## 3. 使用 jq 格式化输出

```bash
# 格式化显示挂载信息
docker inspect mysql | jq '.[0].Mounts'

# 只显示数据卷相关信息
docker inspect mysql | jq '.[0].Mounts[] | select(.Type=="volume")'
```

## 4. 直接查看容器使用的数据卷(推荐) ⭐️⭐️⭐️⭐️⭐️

特别适合：在清理数据卷的情况下，非常有用的命令

```bash
# 查看容器的数据卷使用情况
docker container inspect mysql --format='{{range .Mounts}}{{if eq .Type "volume"}}Volume: {{.Name}} -> {{.Destination}}{{end}}{{end}}'
```

MySQL 容器通常会创建匿名数据卷来存储数据库文件，挂载点通常是 `/var/lib/mysql`。执行上述命令后，你应该能看到类似这样的输出：

```json
[
  {
    "Type": "volume",
    "Name": "67a1378c2926d63282efd949d05e7987f30cebca3c737c21937c792029dc676e",
    "Source": "/var/lib/docker/volumes/67a1378c2926d63282efd949d05e7987f30cebca3c737c21937c792029dc676e/_data",
    "Destination": "/var/lib/mysql",
    "Driver": "local",
    "Mode": "",
    "RW": true,
    "Propagation": ""
  }
]
```

其中 `"Name"` 字段就是你要找的匿名数据卷 ID。

请执行上述命令之一来获取完整的挂载信息，这样就能确定这个 MySQL 容器使用的具体是哪个匿名数据卷了。

如果执行输出为空说明这个 MySQL 容器可能没有使用数据卷，或者使用的是 bind mount 而不是 volume。

### 可能的情况

**情况1：使用了 bind mount** 如果 MySQL 容器是这样启动的：

```bash
docker run -v /host/path:/var/lib/mysql mysql
```

**情况2：没有持久化存储** 如果 MySQL 容器启动时没有指定任何卷：

```bash
docker run mysql
```

这种情况下，数据会存储在容器的可写层中，容器删除后数据就丢失了。

**情况3：使用了匿名卷但检测不到** 有时候镜像本身定义了 VOLUME，但可能在检查时显示不正确。

## 验证方法

```bash
# 1. 查看容器是否有数据持久化
docker exec mysql ls -la /var/lib/mysql

# 2. 查看镜像的 Dockerfile 中是否定义了 VOLUME
docker image inspect mysql | grep -i volume

# 3. 查看容器的完整信息
docker inspect mysql > mysql_inspect.json
```

、