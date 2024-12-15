# Docker export 命令

[Docker命令大全](./docker-command-manual.md)

`docker export` 命令用于将 Docker 容器的文件系统导出为一个 tar 归档文件，主要用于备份或迁移容器的文件系统，而不包括 Docker 镜像的所有层和元数据。

### 语法
docker export [OPTIONS] CONTAINER

OPTIONS说明：

+ `**-o, --output**`: 将输出保存到指定文件，而不是输出到标准输出。

导出容器文件系统：

例：将名为 my_container 的容器的文件系统导出到标准输出。

```shell
docker export my_container
```

将导出文件保存为 tar 文件:

例：将容器 my_container 的文件系统导出并保存到 my_container_backup.tar 文件中。

```shell
docker export my_container > my_container_backup.tar
```

使用 --output 选项保存导出文件:

```shell
# 将容器 my_container 的文件系统导出并保存到 my_container_backup.tar 文件中。
docker export -o my_container_backup.tar my_container
```

### 实例
启动一个容器:

```shell
docker run -d --name my_container ubuntu bash -c "echo hello > /hello.txt && sleep 3600"
```

导出容器的文件系统:

```shell
docker export my_container > my_container_backup.tar
```

查看导出的 tar 文件内容:

```shell
tar -tf my_container_backup.tar
```

输出：

```shell
hello.txt
```

导入文件系统到新的容器:

```shell
cat my_container_backup.tar | docker import - my_new_image
```

### 注意事项
+ `docker export` 只导出容器的文件系统，不包括 Docker 镜像的层、元数据或运行时信息。
+ 如果容器正在运行，导出的文件系统将是容器当前状态的快照。
+ 导出的 tar 文件可能会很大，具体取决于容器的文件系统大小。

`docker export` 命令是一个有用的工具，用于将容器的文件系统导出为 tar 归档文件。这对于备份、迁移和分析容器的文件系统非常有用。通过使用 `--output` 选项，用户可以将导出内容保存为指定文件，方便管理和使用。