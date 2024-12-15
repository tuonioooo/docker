# Docker exec 命令

[Docker命令大全](./docker-command-manual.md)

`docker exec` 命令用于在运行中的容器内执行一个新的命令。这对于调试、运行附加的进程或在容器内部进行管理操作非常有用。

### 语法
docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

### 常用参数
+ `-d, --detach`: 在后台运行命令。
+ `--detach-keys`: 覆盖分离容器的键序列。
+ `-e, --env`: 设置环境变量。
+ `--env-file`: 从文件中读取环境变量。
+ `-i, --interactive`: 保持标准输入打开。
+ `--privileged`: 给这个命令额外的权限。
+ `--user, -u`: 以指定用户的身份运行命令。
+ `--workdir, -w`: 指定命令的工作目录。
+ `-t, --tty`: 分配一个伪终端。

### 实例
在容器内运行命令：

```shell
docker exec my_container ls /app
```

在运行中的 my_container 容器内执行 ls /app 命令，列出 /app 目录的内容。

以交互模式运行命令：

```shell
docker exec -it my_container /bin/bash
```

在运行中的 my_container 容器内启动一个交互式的 Bash shell。-i 保持标准输入打开，-t 分配一个伪终端。

在后台运行命令：

```shell
docker exec -d my_container touch /app/newfile.txt
```

在运行中的 my_container 容器内后台执行 touch /app/newfile.txt 命令，创建一个新文件。

设置环境变量：

```shell
docker exec -e MY_ENV_VAR=my_value my_container env
```

在运行中的 my_container 容器内执行 env 命令，并设置环境变量 MY_ENV_VAR 的值为 my_value。

以指定用户身份运行命令：

```shell
docker exec -u user123 my_container whoami
```

在运行中的 my_container 容器内以 user123 用户身份执行 whoami 命令。

指定工作目录：

```shell
docker exec -w /app my_container pwd
```

在运行中的 my_container 容器内以 /app 目录为工作目录执行 pwd 命令。

### 使用场景
+ **调试容器**: 进入容器内部进行调试和排查问题。
+ **管理任务**: 在容器内运行附加的管理任务或维护操作。
+ **监控和检查**: 在容器内执行监控和检查命令，获取运行状态和日志。

### 总结
`docker exec` 命令是 Docker 中非常强大的工具，允许用户在运行中的容器内执行额外的命令。这对于调试、管理和维护容器非常有用，能够帮助用户更灵活地控制和操作容器内部的环境。

### attach与 exec -it 区别

| **功能点** | **docker attach** | **docker exec -it** |
| --- | --- | --- |
| **目标** | 连接到容器的主进程 | 在容器内启动一个新的进程 |
| **交互模式** | 使用主进程的 STDIN、STDOUT 和 STDERR | 可启动交互式终端（如 bash/sh） |
| **对主进程的影响** | 可能干扰主进程 | 不会干扰主进程 |
| **新进程支持** | 不支持 | 支持 |
| **适用场景** | 查看容器启动日志，直接交互主进程 | 调试、执行命令或管理容器环境 |