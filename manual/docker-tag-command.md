# Docker tag 命令

[Docker命令大全](./docker-command-manual.md)

`docker tag` 命令用于创建本地镜像的别名（tag），通过为镜像打标签，可以使用更容易记忆的名字或版本号来标识和管理镜像。

### 语法
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]

+ `**SOURCE_IMAGE[:TAG]**`: 源镜像名称和标签，标签默认为 `latest`。
+ `**TARGET_IMAGE[:TAG]**`: 目标镜像名称和标签，标签默认为 `latest`。

**1、为镜像打标签**

```shell
docker tag myimage:1.0 myrepo/myimage:latest
```

这会将本地 myimage:1.0 镜像标记为 myrepo/myimage:latest。

**2、为镜像打多个标签**

```shell
docker tag myimage:1.0 myrepo/myimage:stable
docker tag myimage:1.0 myrepo/myimage:v1.0
```

这会将 myimage:1.0 分别标记为 myrepo/myimage:stable 和 myrepo/myimage:v1.0。

**3、为镜像打标签以推送到 Docker Hub**

```shell
docker tag myimage:1.0 myusername/myimage:1.0
docker push myusername/myimage:1.0
```

这会将 myimage:1.0 镜像标记为 myusername/myimage:1.0 并推送到 Docker Hub。

## 实例

### 为镜像打标签
1、列出本地镜像

```shell
docker images
```

```shell
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
myimage             1.0       123456789abc   2 days ago     500MB
```

2、为镜像打标签

```shell
docker tag myimage:1.0 myrepo/myimage:latest
```

3、验证标签

```shell
docker images
```

输出示例：

```shell
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
myimage             1.0       123456789abc   2 days ago     500MB
myrepo/myimage      latest    123456789abc   2 days ago     500MB
```

### 注意事项
+ 标签只是镜像的别名，不会创建新的镜像层，因此不会占用额外的存储空间。
+ 标签应该简洁且具有描述性，以便于识别和管理镜像版本。
+ 在使用标签时，确保命名符合注册表的命名规范。

`docker tag` 命令是管理 Docker 镜像的重要工具，通过为镜像打标签，可以方便地标识、管理和发布不同版本的镜像。这个命令适用于各种场景，包括版本管理、镜像发布和镜像复制。在使用时，确保标签命名规范和描述性，以提高镜像管理的效率和可维护性。

