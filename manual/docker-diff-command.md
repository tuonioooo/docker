# Docker diff 命令

[Docker命令大全](./docker-command-manual.md)

`docker diff` 

命令用于显示 Docker 容器文件系统的变更。它显示自容器创建以来，文件系统中发生的所有修改，包括添加、删除和修改的文件或目录。

对于调试和理解容器的文件系统变化非常有用。

### 语法
docker diff CONTAINER

+ `CONTAINER`: 容器的名称或 ID。

`docker diff` 命令的输出包含以下三种类型的变更：

+ `A`: 表示新增的文件或目录。
+ `D`: 表示删除的文件或目录。
+ `C`: 表示修改过的文件或目录。

**查看容器的文件系统变更**

例：显示名为 my_container 的容器的文件系统变更。

```shell
docker diff my_container
```

### 实例
启动一个容器并修改文件系统:

```shell
docker run -d --name my_container ubuntu bash -c "echo 'Hello, Docker!' > /hello.txt && sleep 3600"
```

查看容器的文件系统变更:

```shell
docker diff my_container
```

输出示例：

```shell
A /hello.txt
```

此输出表示 /hello.txt 文件在容器文件系统中被新增了。

删除容器中的文件:

```shell
docker exec my_container rm /hello.txt
```

再次查看容器的文件系统变更:

```shell
docker diff my_container
```

输出示例：

```shell
D /hello.txt
```

此输出表示 /hello.txt 文件在容器文件系统中被删除了。

### 注意事项
+ `docker diff` 命令仅显示容器的文件系统变化，不显示容器内的其他状态信息（如运行的进程）。
+ 输出信息可能会因容器内文件系统的变化而不断变化，因此应在需要时及时查看。

`docker diff` 命令是一个强大的工具，用于显示 Docker 容器文件系统的变化。通过使用该命令，用户可以轻松查看和了解容器自创建以来所做的文件系统更改，有助于调试、审计和分析容器的行为。