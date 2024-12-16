# Docker 清理命令

[Docker命令大全](./docker-command-manual.md)

#### 杀死所有正在运行的容器

```shell
docker kill $(docker ps -a -q)
```

#### 删除所有已经停止的容器
```shell
docker rm $(docker ps -a -q)
```

#### 删除所有未打 dangling 标签的镜像
```shell
docker rmi $(docker images -q -f dangling=true)
```

#### 通过镜像的id来删除指定镜像
```shell
docker rmi <image id>
```

#### 删除所有镜像
```shell
docker rmi $(docker images -q)
```

#### 为这些命令创建别名
```shell
# ~/.bash_aliases

# 杀死所有正在运行的容器.
alias dockerkill='docker kill $(docker ps -a -q)'

# 删除所有已经停止的容器.
alias dockercleanc='docker rm $(docker ps -a -q)'

# 删除所有未打标签的镜像.
alias dockercleani='docker rmi $(docker images -q -f dangling=true)'

# 删除所有已经停止的容器和未打标签的镜像.
alias dockerclean='dockercleanc || true && dockercleani'
```

