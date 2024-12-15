# Docker info 命令

[Docker命令大全](./docker-command-manual.md)

docker info 命令用于显示 Docker 系统的详细信息，包括 Docker 版本、存储驱动、镜像数量、容器数量以及其他重要的配置信息。

docker info 命令非常有用，可以帮助用户了解 Docker 环境的总体状态。

### 语法
docker info [OPTIONS]

### 实例
查看docker系统信息。

```plain
$ docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc., 0.8.1)
  compose: Docker Compose (Docker Inc., 2.3.3)

Server:
 Containers: 3
  Running: 1
  Paused: 0
  Stopped: 2
 Images: 10
 Server Version: 20.10.7
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: d71fcd7d8303cbf684402823e425e9dd2e99285d
 runc version: b9ee9c6314599f1b4a7f497e1f1f856fe433d3b7
 init version: de40ad0
 Security Options:
  seccomp
   Profile: default
  selinux
 Kernel Version: 5.10.25-linuxkit
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 1.942GiB
 Name: docker-desktop
 ID: 3WZ2:ZQ7K:6K4E:6ZCR:YITZ:GH2S:6NUB:HTB5:OS7K:AAUI:K7CC:JZL3
 Docker Root Dir: /var/lib/docker
 Debug Mode: true
  File Descriptors: 45
  Goroutines: 49
  System Time: 2024-07-23T09:41:47.2527914Z
  EventsListeners: 4
 HTTP Proxy: http://proxy.example.com:80
 HTTPS Proxy: https://proxy.example.com:443
 No Proxy: localhost,127.0.0.1,docker-registry.example.com
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Registry Mirrors:
 Live Restore Enabled: false

WARNING: No swap limit support
```

### 输出解释
**Client**: Docker 客户端的相关信息。

+ `Context`: 当前 Docker 上下文。
+ `Debug Mode`: 客户端是否开启调试模式。
+ `Plugins`: 安装的客户端插件，如 `buildx` 和 `compose`。

**Server**: Docker 服务端（守护进程）的相关信息。

+ `Containers`: 容器的总数。
    - `Running`: 运行中的容器数量。
    - `Paused`: 暂停中的容器数量。
    - `Stopped`: 停止的容器数量。
+ `Images`: 镜像的总数。
+ `Server Version`: Docker 服务端的版本号。
+ `Storage Driver`: 使用的存储驱动（如 `overlay2`）。
+ `Backing Filesystem`: 后端文件系统类型。
+ `Supports d_type`: 是否支持 `d_type`。
+ `Native Overlay Diff`: 是否支持原生 Overlay 文件系统。
+ `Logging Driver`: 使用的日志驱动（如 `json-file`）。
+ `Cgroup Driver`: 使用的 Cgroup 驱动（如 `cgroupfs`）。
+ `Cgroup Version`: Cgroup 的版本（如 `1`）。
+ `Plugins`: 服务端插件列表，包括卷、网络和日志插件。
+ `Swarm`: Swarm 模式的状态（如 `inactive`）。
+ `Runtimes`: 支持的运行时（如 `runc`）。
+ `Default Runtime`: 默认运行时（如 `runc`）。
+ `Init Binary`: 初始化二进制文件（如 `docker-init`）。
+ `containerd version`: 使用的 `containerd` 版本。
+ `runc version`: 使用的 `runc` 版本。
+ `init version`: 使用的 `init` 版本。
+ `Security Options`: 启用的安全选项（如 `seccomp` 和 `selinux`）。
+ `Kernel Version`: 内核版本。
+ `Operating System`: 操作系统名称。
+ `OSType`: 操作系统类型（如 `linux`）。
+ `Architecture`: 系统架构（如 `x86_64`）。
+ `CPUs`: CPU 数量。
+ `Total Memory`: 总内存。
+ `Name`: Docker 主机名。
+ `ID`: Docker 实例 ID。
+ `Docker Root Dir`: Docker 根目录。
+ `Debug Mode`: 服务端是否开启调试模式。
    - `File Descriptors`: 文件描述符数量。
    - `Goroutines`: Goroutines 数量。
    - `System Time`: 系统时间。
    - `EventsListeners`: 事件监听器数量。
+ `HTTP Proxy`: 配置的 HTTP 代理。
+ `HTTPS Proxy`: 配置的 HTTPS 代理。
+ `No Proxy`: 不使用代理的地址列表。
+ `Registry`: 使用的注册表地址。
+ `Labels`: 配置的标签。
+ `Experimental`: 是否启用了实验性功能。
+ `Insecure Registries`: 配置的不安全注册表列表。
+ `Registry Mirrors`: 注册表镜像列表。
+ `Live Restore Enabled`: 是否启用了实时恢复功能。

**WARNING**: 警告信息（如没有启用 swap 限制支持）。

