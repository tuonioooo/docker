# Docker version 命令

[Docker命令大全](./docker-command-manual.md)

docker version 

命令用于显示 Docker 客户端和服务端的版本详细信息，另外还有一个 **docker --version** 命令是用于显示 Docker 的版本信息。

### 语法
docker version [OPTIONS]

OPTIONS说明：

+ **-f :**指定返回值的模板文件。

### 实例
显示 Docker 版本信息。

```shell
docker version
Client: Docker Engine - Community
 Version:           20.10.7
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        f0df350
 Built:             Wed Jun  2 11:57:37 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.7
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       b0f5bc3
  Built:            Wed Jun  2 11:55:47 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.6
  GitCommit:        d71fcd7d8303cbf684402823e425e9dd2e99285d
 runc:
  Version:          1.0.0-rc95
  GitCommit:        b9ee9c6314599f1b4a7f497e1f1f856fe433d3b7
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

### 输出解释
**Client**: Docker 客户端的相关信息。

+ `Version`: 客户端的版本号。
+ `API version`: API 的版本号。
+ `Go version`: 编译 Docker 客户端所用的 Go 语言版本。
+ `Git commit`: 该版本对应的 Git 提交 ID。
+ `Built`: 构建日期。
+ `OS/Arch`: 操作系统和架构。
+ `Context`: 当前 Docker 上下文。
+ `Experimental`: 是否启用了实验性功能。

**Server**: Docker 服务端（守护进程）的相关信息。

+ `Engine`:
    - `Version`: 服务端的版本号。
    - `API version`: API 的版本号（以及支持的最低版本）。
    - `Go version`: 编译 Docker 服务端所用的 Go 语言版本。
    - `Git commit`: 该版本对应的 Git 提交 ID。
    - `Built`: 构建日期。
    - `OS/Arch`: 操作系统和架构。
    - `Experimental`: 是否启用了实验性功能。
+ `containerd`: Docker 使用的 containerd 版本和 Git 提交 ID。
+ `runc`: Docker 使用的 runc 版本和 Git 提交 ID。
+ `docker-init`: Docker 使用的 docker-init 版本和 Git 提交 ID。

