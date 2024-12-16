# Docker pull 命令

[Docker命令大全](./docker-command-manual.md)

`docker pull` 

命令用于从 Docker 注册表（例如 Docker Hub）中拉取（下载）镜像到本地，允许用户获取所需的镜像以便在本地运行容器。

### 语法
docker pull [OPTIONS] NAME[:TAG|@DIGEST]

+ `NAME`: 镜像名称，通常包含注册表地址（如 `docker.io/library/ubuntu`）。
+ `TAG`（可选）: 镜像标签，默认为 `latest`。
+ `DIGEST`（可选）: 镜像的 SHA256 摘要。

常用选项：

+ `--all-tags, -a`: 下载指定镜像的所有标签。
+ `--disable-content-trust`: 跳过镜像签名验证。

**1、拉取默认标签（latest）的镜像**

从 Docker Hub 拉取名为 ubuntu 的镜像，标签默认为 latest。

```shell
docker pull ubuntu
```

**2、拉取特定标签的镜像**

从 Docker Hub 拉取名为 ubuntu 的镜像，标签为 20.04。

```shell
docker pull ubuntu:20.04
```

**3、拉取特定摘要的镜像**

拉取具有特定 SHA256 摘要的 ubuntu 镜像。

```shell
docker pull ubuntu@sha256:12345abcdef...
```

**4、拉取所有标签的镜像**

拉取 ubuntu 镜像的所有可用标签。

```shell
docker pull --all-tags ubuntu
```

**5、从自定义注册表拉取镜像**

从 myregistry.com 注册表中拉取 myrepo 仓库中的 myimage 镜像，标签为 mytag。

```shell
docker pull myregistry.com/myrepo/myimage:mytag
```

### 实例
1、拉取 Ubuntu 镜像：

```shell
docker pull ubuntu
```

输出示例：

```shell
Using default tag: latest
latest: Pulling from library/ubuntu
Digest: sha256:12345abcdef...
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest
```

2、拉取指定标签的 Ubuntu 镜像

```shell
docker pull ubuntu:20.04
```

输出示例：

```shell
20.04: Pulling from library/ubuntu
Digest: sha256:67890abcdef...
Status: Downloaded newer image for ubuntu:20.04
docker.io/library/ubuntu:20.04
```

### 注意事项
+ 默认标签为 `latest`，但最好显式指定标签以避免拉取意外的版本。
+ 确保有足够的磁盘空间来存储拉取的镜像。
+ 在生产环境中，建议使用镜像的摘要（digest）以确保镜像的唯一性和一致性。

`docker pull` 命令是获取 Docker 镜像的基本工具，通过指定镜像名称、标签或摘要，可以从 Docker 注册表中下载所需的镜像。