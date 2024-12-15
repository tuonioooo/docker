# Docker命令大全

### 容器生命周期管理

+ [run - 创建并启动一个新的容器。](./docker-run-command.md)
+ [start/stop/restart - 这些命令主要用于启动、停止和重启容器。](./docker-start-stop-restart-command.md)
+ [kill - 立即终止一个或多个正在运行的容器](./docker-kill-command.md)
+ [rm - 删除一个或多个已经停止的容器。](./docker-rm-command.md)
+ [pause/unpause - 暂停和恢复容器中的所有进程。](./docker-pause-unpause-command.md)
+ [create - 创建一个新的容器，但不会启动它。](./docker-create-command.md)
+ [exec - 在运行中的容器内执行一个新的命令。](./docker-exec-command.md)
+ [rename - 重命名容器。](./docker-rename-command.md)

### 容器操作
+ [ps - 列出 Docker 容器](./docker-ps-command.md)
+ [inspect - 获取 Docker 对象（容器、镜像、卷、网络等）的详细信息。](./docker-inspect-command.md)
+ [top - 显示指定容器中的正在运行的进程。](./docker-top-command.md)
+ [attach - 允许用户附加到正在运行的容器并与其交互。](./docker-attach-command.md)
+ [events - 获取 Docker 守护进程生成的事件。](./docker-events-command.md)
+ [logs - 获取和查看容器的日志输出。](./docker-logs-command.md)
+ [wait - 允许用户等待容器停止并获取其退出代码。](./docker-wait-command.md)
+ [export - 将容器的文件系统导出为 tar 归档文件。](./docker-export-command.md)
+ [port - 显示容器的端口映射信息。](./docker-port-command.md)
+ [stats - 实时显示 Docker 容器的资源使用情况。](./docker-stats-command.md)

### 容器的root文件系统（rootfs）命令
+ [commit - 允许用户将容器的当前状态保存为新的 Docker 镜像。](./docker-commit-command.md)
+ [cp - 用于在容器和宿主机之间复制文件或目录。](./docker-cp-command.md)
+ [diff - 显示 Docker 容器文件系统的变更。](./docker-diff-command.md)

### 镜像仓库
+ [login/logout - 管理 Docker 客户端与 Docker 注册表的身份验证。](./docker-login-logout-command.md)
+ [pull - 从 Docker 注册表（例如 Docker Hub）中拉取（下载）镜像到本地。](./docker-pull-command.md)
+ [push - 将本地构建的 Docker 镜像推送（上传）到 Docker 注册表（如 Docker Hub 或私有注册表）。](./docker-push-command.md)
+ [search - 用于在 Docker Hub 或其他注册表中搜索镜像。](./docker-search-command.md)

### 本地镜像管理
+ [images - 列出本地的 Docker 镜像。](./docker-images-command.md)
+ [rmi - 删除不再需要的镜像。](./docker-rmi-command.md)
+ [tag - 创建本地镜像的别名（tag）。](./docker-tag-command.md)
+ [build - 从 Dockerfile 构建 Docker 镜像。](./docker-build-command.md)
+ [history - 查看指定镜像的历史层信息。](./docker-history-command.md)
+ [save - 将一个或多个 Docker 镜像保存到一个 tar 归档文件中。](./docker-save-command.md)
+ [load - 从由 docker save 命令生成的 tar 文件中加载 Docker 镜像。](./docker-load-command.md)
+ [import - 从一个 tar 文件或 URL 导入容器快照，从而创建一个新的 Docker 镜像。](./docker-import-command.md)

### info|version
+ [info - 显示 Docker 的系统级信息，包括当前的镜像和容器数量。](./docker-info-command.md)
+ [version - 显示 Docker 客户端和服务端的版本信息。](./docker-version-command.md)

### Docker Compose（推荐）
+ [docker compose 基本命令](./docker-compose-run-command.md)

### Docker-Compose（逐步被淘汰，兼容旧版本）
* [docker-compose 构建jenkins](../docker-compose/docker-compose-jenkins.md)
* [docker-compose 构建mySql](../docker-compose/docker-compose-mysql.md)
* [docker-compose 构建redis](../docker-compose/docker-compose-redis.md)
* [docker-compose 构建nginx](../docker-compose/docker-compose-nginx.md)
* [docker-compose 网络配置](../docker-compose/docker-compose-network.md)
* [docker-compose 编排多服务](../docker-compose/docker-compose-build-servers.md)
* [docker-compose 常用命令](../docker-compose/docker-compose-common-command.md)

### 网络命令
+ `docker network ls`: 列出所有网络。
+ `docker network create <network>`: 创建一个新的网络。
+ `docker network rm <network>`: 删除指定的网络。
+ `docker network connect <network> <container>`: 连接容器到网络。
+ `docker network disconnect <network> <container>`: 断开容器与网络的连接。

详细内容查看：[docker network 命令](./docker-network-command.md)

### 卷命令
+ `docker volume ls`: 列出所有卷。
+ `docker volume create <volume>`: 创建一个新的卷。
+ `docker volume rm <volume>`: 删除指定的卷。
+ `docker volume inspect <volume>`: 显示卷的详细信息。

详细内容查看：[docker volume 命令](./docker-volume-command.md)

### 设置开机启动
```shell
# CentOS6语法：
service docker start
chkconfig docker on

# CentOS7语法：
systemctl start docker.service
systemctl enable docker.service
```

### 清理命令

* [docker 清理命令](./docker-clear-command.md)

### 命令区分
* [docker import、export与save、load区别](./diff/docker-import-export-save-load-diff.md)
* [docker Compose、docker-compose命令区别](./diff/docker-compose-vs-compose-diff.md)