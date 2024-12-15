# Docker run 命令

[Docker命令大全](./docker-command-manual.md)

docker run 命令用于创建并启动一个新的容器。

### 语法
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

常用参数说明：

+ `-d`: 后台运行容器并返回容器 ID。
+ `-it`: 交互式运行容器，分配一个伪终端。
+ `--name`: 给容器指定一个名称。
+ `-p`: 端口映射，格式为 `host_port:container_port`。
+ `-v`: 挂载卷，格式为 `host_dir:container_dir`。
+ `--rm`: 容器停止后自动删除容器。
+ `--env` 或 `-e`: 设置环境变量。
+ `--network`: 指定容器的网络模式。
+ `--restart`: 容器的重启策略（如 `no`、`on-failure`、`always`、`unless-stopped`）。
+ `-u`: 指定用户。

### 实例

#### 1. 基本使用

例：拉取 ubuntu 镜像并在前台启动一个容器。

```shell
docker run ubuntu
```

#### 2. 后台运行容器

例：在后台运行 ubuntu 容器并返回容器 ID。

```shell
docker run -d ubuntu
```

#### 3. 交互式运行并分配终端

例：以交互模式运行 ubuntu 容器，并启动一个 Bash shell。

```shell
docker run -it ubuntu /bin/bash
```

输出

```shell
$:/# 

#从容器中退回主机
[root@8631de5eaae9 /]# exit
exit
[root@localhost ~]#
```

#### 4. 指定容器名称

例：运行一个 ubuntu 容器，并将其命名为 my_container。

```shell
docker run --name my_container ubuntu
```

#### 5. 端口映射

例：将本地主机的 8080 端口映射到容器内的 80 端口，运行 nginx 容器。

```shell
docker run -p 8080:80 nginx
```

#### 6. 挂载卷

例：将主机的 /host/data 目录挂载到容器内的 /container/data 目录。

```shell
docker run -v /host/data:/container/data ubuntu
```

#### 7. 设置环境变量

例：设置环境变量 MY_ENV_VAR 的值为 my_value，运行 ubuntu 容器。

```shell
docker run -e MY_ENV_VAR=my_value ubuntu
```

#### 8. 使用网络模式

例：使用主机的网络模式运行 nginx 容器。

```shell
docker run --network host nginx
```

#### 9. 指定重启策略

例：设置容器的重启策略为 always，即使容器停止也会自动重启。

```shell
docker run --restart always nginx
```

#### 10. 指定用户

例：以 user123 用户运行 ubuntu 容器。

```shell
docker run -u user123 ubuntu
```

#### 11. 组合多个选项

例：后台运行一个命名为 webserver 的 nginx 容器，将主机的 8080 端口映射到容器的 80 端口，并将主机的 /host/data 目录挂载到容器的 /data 目录。

```shell
docker run -d -p 8080:80 -v /host/data:/data --name webserver nginx
```

> 参数说明：
>
> + `-d`: 后台运行容器并返回容器 ID。
> + `-p 8080:80`:	将主机的 8080 端口映射到容器的 80 端口
> + `-v /host/data:/data`: 将主机的 /host/data 目录挂载到容器的 /data 目录。
> + `--name webserver`: 指定容器的名称