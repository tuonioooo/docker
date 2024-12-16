# Docker cp 命令

[Docker命令大全](./docker-command-manual.md)

`docker cp` 

命令用于在 Docker 容器和宿主机之间复制文件或目录，支持从容器到宿主机，或从宿主机到容器的文件复制操作。

### 语法
```shell
docker cp [OPTIONS] SRC_PATH CONTAINER:DEST_PATH
docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH
```

+ `SRC_PATH`: 源路径（可以是容器内的路径或宿主机的路径）。
+ `CONTAINER`: 容器的名称或 ID。
+ `DEST_PATH`: 目标路径（可以是容器内的路径或宿主机的路径）。

**从容器复制文件到宿主机**

例：将容器 my_container 内的 /path/in/container 文件或目录复制到宿主机的 /path/on/host。

```shell
docker cp my_container:/path/in/container /path/on/host
```

**从宿主机复制文件到容器**

例：将宿主机上的 /path/on/host 文件或目录复制到容器 my_container 内的 /path/in/container。

```shell
docker cp /path/on/host my_container:/path/in/container
```

**从容器复制目录到宿主机**

例：将容器内的 /path/in/container 目录及其内容复制到宿主机的 /path/on/host。

```shell
docker cp my_container:/path/in/container /path/on/host
```

**从宿主机复制目录到容器**

例：将宿主机上的 /path/on/host 目录及其内容复制到容器 my_container 内的 /path/in/container。

```shell
docker cp /path/on/host my_container:/path/in/container
```

## 实例
### 容器复制文件到宿主机
启动一个容器并创建一个文件:

```shell
docker run -d --name my_container ubuntu bash -c "echo 'Hello, Docker!' > /hello.txt"
```

从容器复制文件到宿主机，将容器内的 /hello.txt 文件复制到当前宿主机目录下。

```shell
docker cp my_container:/hello.txt ./hello.txt
```

查看复制的文件内容:

```shell
cat hello.txt
```

输出：

```shell
Hello, Docker!
```

### 从宿主机复制文件到容器
复制一个文件到容器，将宿主机上的 hello.txt 文件复制到容器内的 /hello.txt。

```shell
docker cp ./hello.txt my_container:/hello.txt
```

进入容器查看文件内容:

```shell
docker exec -it my_container cat /hello.txt
```

输出：

```shell
Hello, Docker!
```

### 注意事项
+ `docker cp` 命令不会修改源文件或目录，它仅进行复制操作。
+ 目标路径必须是有效的路径，且宿主机或容器中应有足够的权限进行写入操作。
+ 在处理大文件或大目录时，复制操作可能需要一些时间。

`docker cp` 命令是 Docker 提供的一个有用工具，用于在容器和宿主机之间复制文件或目录。这个命令适用于备份、配置更新、日志收集等操作，帮助用户方便地管理和操作容器中的文件。