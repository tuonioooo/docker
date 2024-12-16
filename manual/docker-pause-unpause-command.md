# Docker pause/unpause 命令

[Docker命令大全](./docker-command-manual.md)

**docker pause** - 暂停容器中所有的进程。

**docker unpause** - 恢复容器中所有的进程。

暂停的容器不会被终止，但其进程将被挂起，直到容器被恢复。这在需要临时暂停容器活动的情况下非常有用。

---

## docker pause 命令
docker pause 命令用于暂停一个或多个容器中的所有进程。

### 语法
docker pause CONTAINER [CONTAINER...]

### 实例
暂停一个容器：

```shell
docker pause my_container
```

暂停名称为 my_container 的容器中的所有进程。

暂停多个容器：

```shell
docker pause container1 container2
```

同时暂停 container1 和 container2 容器中的所有进程。

---

## docker unpause 命令
docker unpause 命令用于恢复一个或多个已暂停容器中的所有进程。

### 语法
docker unpause CONTAINER [CONTAINER...]

### 实例
恢复一个容器：

```shell
docker unpause my_container
```

恢复名称为 my_container 的容器中的所有进程。

恢复多个容器：

```shell
docker unpause container1 container2
```

同时恢复 container1 和 container2 容器中的所有进程。

### 使用场景
+ **临时暂停活动**: 当需要临时暂停容器中的所有活动以进行系统维护或资源管理时，可以使用 `docker pause`。
+ **资源管理**: 在需要重新分配系统资源时，暂停不必要的容器以释放资源。
+ **调试和故障排除**: 在调试或故障排除过程中暂停容器以分析当前状态。

### 总结
+ `docker pause`: 用于暂停容器中的所有进程。暂停的容器仍然存在，但其进程将挂起，直到恢复。
+ `docker unpause`: 用于恢复已暂停容器中的所有进程，使其恢复正常运行。

  