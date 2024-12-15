# Docker import 命令

[Docker命令大全](./docker-command-manual.md)

`docker import` 命令用于从一个 tar 文件或 URL 导入容器快照，从而创建一个新的 Docker 镜像。

与 `docker load` 不同，`docker import` 可以从容器快照中创建新的镜像，而不需要保留镜像的历史和元数据。

### 语法
docker import [OPTIONS] file|URL|- [REPOSITORY[:TAG]]

+ `**file|URL|-**`: 输入文件的路径、本地文件或 URL，或者使用 `-` 从标准输入读取。
+ `**[REPOSITORY[:TAG]]**`: （可选）为导入的镜像指定仓库和标签。

OPTIONS 说明：

+ `**-c, --change**`: 在导入过程中应用 Dockerfile 指令，如 `CMD`、`ENTRYPOINT`、`ENV` 等。
+ `**-m, --message**`: 为导入的镜像添加注释。

1、从本地 tar 文件导入镜像

例：从 mycontainer.tar 文件导入镜像，并命名为 mynewimage:latest。

```shell
docker import mycontainer.tar mynewimage:latest
```

2、从 URL 导入镜像

例：从指定的 URL 导入镜像，并命名为 mynewimage:latest。

```shell
docker import http://example.com/mycontainer.tar mynewimage:latest
```

3、从标准输入导入镜像

例：通过管道从标准输入读取 tar 文件并导入镜像。

```shell
cat mycontainer.tar | docker import - mynewimage:latest
```

4、在导入过程中应用变更

例：从 mycontainer.tar 导入镜像，并在过程中设置环境变量 LANG 和命令 CMD。

```shell
docker import -c "ENV LANG=en_US.UTF-8" -c "CMD /bin/bash" mycontainer.tar mynewimage:latest
```

## 实例
**1、导出容器快照**

首先，创建并运行一个容器：

```shell
docker run -d --name mycontainer ubuntu:20.04 sleep 3600
```

导出容器快照：

```shell
docker export mycontainer -o mycontainer.tar
```

**2、导入容器快照**

从 tar 文件导入镜像：

```shell
docker import mycontainer.tar mynewimage:latest
```

**3、验证导入的镜像**

```shell
docker images
```

输出示例：

```shell
REPOSITORY     TAG       IMAGE ID            CREATED             SIZE
mynewimage     latest    123abc456def        1 minute ago        72.9MB
```

**4、运行导入的镜像**

```shell
docker run -it mynewimage:latest /bin/bash
```

### 注意事项
+ `docker import` 创建的镜像不会保留原始镜像的历史和元数据。
+ 使用 `-c` 选项可以在导入过程中应用 Dockerfile 指令，从而自定义新镜像的配置。
+ 导入的 tar 文件必须是使用 `docker export` 创建的容器快照，或者是兼容的其他格式。

`docker import` 命令是一种从容器快照创建新镜像的灵活方法，适用于迁移、恢复和自定义 Docker 镜像的场景。通过使用 `docker import`，用户可以轻松地从容器快照生成新的镜像，并在导入过程中应用额外的配置。

