# Docker push 命令

[Docker命令大全](./docker-command-manual.md)

`docker push` 

命令用于将本地构建的 Docker 镜像推送（上传）到 Docker 注册表（如 Docker Hub 或私有注册表）。这使得镜像可以在其他系统或环境中共享和使用。

### 语法
docker push [OPTIONS] NAME[:TAG]

+ `NAME`: 镜像名称，通常包含注册表地址（如 `docker.io/myrepo/myimage`）。
+ `TAG`（可选）: 镜像标签，默认为 `latest`。

OPTIONS 说明：

+ **--disable-content-trust :**忽略镜像的校验,默认开启

**1、推送默认标签（latest）的镜像**

```shell
docker push myrepo/myimage
```

这会将本地的 myrepo/myimage:latest 镜像推送到 Docker Hub。

**2、推送特定标签的镜像**

```shell
docker push myrepo/myimage:1.0
```

这会将本地的 myrepo/myimage:1.0 镜像推送到 Docker Hub。

**3、推送到自定义注册表**

```shell
docker push myregistry.com/myrepo/myimage:mytag
```

这会将本地的 myrepo/myimage:mytag 镜像推送到 myregistry.com 注册表。

## 实例
### 推送镜像到 Docker Hub
1、登录到 Docker Hub

```shell
docker login
```

2、构建一个镜像

```shell
docker build -t myrepo/myimage:1.0 .
```

3、推送镜像到 Docker Hub

```shell
docker push myrepo/myimage:1.0
```

输出示例：

```shell
The push refers to repository [docker.io/myrepo/myimage]
d1e017099d17: Pushed
1.0: digest: sha256:12345abcdef... size: 1234
```

### 推送镜像到自定义注册表
1、登录到自定义注册表

```shell
docker login myregistry.com
```

2、构建一个镜像

```shell
docker build -t myregistry.com/myrepo/myimage:mytag .
```

3、推送镜像到自定义注册表

```shell
docker push myregistry.com/myrepo/myimage:mytag
```

输出示例：

```shell
The push refers to repository [myregistry.com/myrepo/myimage]
d1e017099d17: Pushed
mytag: digest: sha256:67890abcdef... size: 5678
```

### 注意事项
+ 确保已登录到目标注册表（使用 `docker login` 命令）。
+ 在推送镜像之前，确保镜像标签正确，并符合注册表的命名规范。
+ 推送操作需要网络连接，镜像大小和网络速度会影响推送时间。
+ 对于私有注册表，确保拥有相应的访问权限和配置信息。

`docker push` 命令是将本地 Docker 镜像推送到注册表的关键工具，通过使用这个命令，用户可以方便地共享、部署和管理 Docker 镜像。在使用时，确保正确登录和标签设置，以保证镜像能够正确推送到目标注册表。