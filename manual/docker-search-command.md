# Docker search 命令

[Docker命令大全](./docker-command-manual.md)

`docker search` 

命令用于在 Docker Hub 或其他注册表中搜索镜像，帮助用户查找和获取所需的镜像，并提供了对搜索结果进行过滤和排序的功能。

### 语法
docker search [OPTIONS] TERM

+ `**TERM**`: 要搜索的关键字。

常用选项：

+ **--automated :**只列出 automated build类型的镜像；
+ **--no-trunc :**显示完整的镜像描述；
+ **-f <过滤条件>:**列出收藏数不小于指定值的镜像。

**1、搜索镜像**

**例：**在 Docker Hub 中搜索包含关键字 ubuntu 的镜像。

```shell
docker search ubuntu
```

**2、限制返回的搜索结果数量**

**例：**在 Docker Hub 中搜索包含关键字 ubuntu 的镜像，并只返回前 5 个结果。

```shell
docker search --limit 5 ubuntu
```

**3、过滤搜索结果**

**例：**在 Docker Hub 中搜索包含关键字 ubuntu 的镜像，并只返回 stars 数不低于 50 的镜像。

```shell
docker search --filter stars=50 ubuntu
```

**4、不截断输出**

**例：**在 Docker Hub 中搜索包含关键字 ubuntu 的镜像，并显示完整的镜像描述。

```shell
docker search --no-trunc ubuntu
```

**5、自定义格式输出**

**例：**在 Docker Hub 中搜索包含关键字 ubuntu 的镜像，并以指定格式显示镜像名称和 star 数。

```shell
docker search --format "{{.Name}}: {{.StarCount}} stars" ubuntu
```

### 实例
1、搜索 Ubuntu 镜像

```shell
docker search ubuntu
```

输出示例：

```shell
NAME                             DESCRIPTION                                     STARS   OFFICIAL  AUTOMATED
ubuntu                           Ubuntu is a Debian-based Linux operating sys…   10000   [OK]
dorowu/ubuntu-desktop-lxde-vnc   Ubuntu with openssh-server and NoVNC            4000               [OK]
rastasheep/ubuntu-sshd           Dockerized SSH service, built on top of offi…   2000               [OK]
```

参数说明：

**NAME:** 镜像仓库源的名称

**DESCRIPTION:**镜像的描述

**OFFICIAL:**是否 docker 官方发布

**stars:**类似 Github 里面的 star，表示点赞、喜欢的意思。

**AUTOMATED:**自动构建。

2、限制返回结果数量

```shell
docker search --limit 3 ubuntu
```

输出示例：

```shell
NAME                              DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
ubuntu                            Ubuntu is a Debian-based Linux operating sys…   10000     [OK]
dorowu/ubuntu-desktop-lxde-vnc    Ubuntu with openssh-server and NoVNC            4000                 [OK]
rastasheep/ubuntu-sshd            Dockerized SSH service, built on top of offi…   2000                 [OK]
```

3、过滤搜索结果

```shell
docker search --filter stars=1000 ubuntu
```

输出示例：

```shell
NAME                            DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
ubuntu                          Ubuntu is a Debian-based Linux operating sys…   10000     [OK]
dorowu/ubuntu-desktop-lxde-vnc  Ubuntu with openssh-server and NoVNC            4000                 [OK]
rastasheep/ubuntu-sshd          Dockerized SSH service, built on top of offi…   2000                 [OK]
```

### 4、自定义格式输出
```shell
docker search --format "{{.Name}}: {{.StarCount}} stars" ubuntu
```

输出示例：

```shell
ubuntu: 10000 stars
dorowu/ubuntu-desktop-lxde-vnc: 4000 stars
rastasheep/ubuntu-sshd: 2000 stars
```

### 注意事项
+ 搜索结果可能包含大量镜像，可以使用过滤和排序选项来精简结果。
+ 确保使用准确的关键字以获取相关结果。
+ `docker search` 默认搜索 Docker Hub，若需要搜索其他注册表，需相应配置 Docker 客户端。

`docker search` 命令是查找 Docker 镜像的重要工具，通过指定关键字和选项，用户可以高效地在 Docker 注册表中搜索和获取所需的镜像。这个命令适用于各种场景，包括查找特定功能的镜像、获取高评分镜像以及自定义结果显示。