# Docker rename 命令

[Docker命令大全](./docker-command-manual.md)

docker rename 命令用于重命名已存在的容器。该命令允许你在不停止或删除容器的情况下，直接修改容器的名称。

### 语法
docker rename <当前容器名称或ID> <新容器名称>

常用参数说明：

+ **当前容器名称或ID**：需要修改名称的现有容器的名称或者 ID。
+ **新容器名称**：将容器重命名为指定的新名称。这个名称必须唯一，不能与其他正在运行的容器冲突。

### 实例
**1、重命名容器**

假设有一个正在运行的容器，名称为 my_old_container，并且需要将它重命名为 my_new_container：

```shell
docker rename my_old_container my_new_container
```

执行成功后，容器的名称将变为 my_new_container。你可以通过以下命令确认：

```shell
docker ps -a
```

**2、使用容器 ID 重命名**

如果你不知道容器的名称，但知道其 ID，可以使用容器的 ID 来重命名。例如：

```shell
docker rename 123abc456def my_new_container
```

同样，123abc456def 是容器的 ID，重命名后可以通过 docker ps -a 查看。

**3、检查是否重名**

如果你尝试重命名的名称已经被其他容器使用，Docker 会返回错误：

```shell
docker rename my_old_container existing_container_name
```

输出：

```plain
Error response from daemon: Conflict. 
The container name "/existing_container_name" is already in use by container "abc123".
You have to remove (or rename) that container to be able to reuse that name.
```

此时需要先重命名或移除 existing_container_name 的容器，然后再进行操作。