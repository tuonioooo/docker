# Docker清理数据卷(volume prune)

Docker volume prune 是 Docker 提供的一个清理命令，用于删除不再使用的数据卷，帮助释放磁盘空间。

## 命令介绍

`docker volume prune` 会删除所有未被任何容器使用的匿名数据卷。这些"悬空"的数据卷通常是在容器删除后遗留下来的，占用磁盘空间但不再有用。

## 基本语法

```bash
docker volume prune [OPTIONS]
```

## 常用选项

- `-f, --force`: 强制删除，不提示确认
- `--filter`: 根据条件过滤要删除的数据卷

## 使用示例

### 1. 基本使用
```bash
# 删除所有未使用的数据卷（会提示确认）
docker volume prune

# 强制删除，不提示确认
docker volume prune -f
```

### 2. 使用过滤器
```bash
# 删除指定时间之前创建的未使用数据卷
docker volume prune --filter "until=24h"

# 保留最近10天的缓存
docker builder prune --filter 'until=240h'

# 删除带有特定标签的未使用数据卷
docker volume prune --filter "label=environment=test"
```

### 3. 结合其他清理命令
```bash
# 清理整个 Docker 环境
docker system prune -a --volumes

# 只清理数据卷
docker volume prune -f
```

## 常见使用场景

### 1. 定期维护
在开发环境中定期清理不再使用的数据卷，防止磁盘空间被浪费：
```bash
# 每周执行一次清理
docker volume prune -f
```

### 2. CI/CD 流水线
在持续集成环境中，测试完成后清理临时数据卷：
```bash
# 测试完成后清理
docker-compose down --volumes
docker volume prune -f
```

### 3. 开发环境重置
重新开始项目开发时，清理所有相关数据：
```bash
# 停止所有容器并清理数据卷
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker volume prune -f
```

### 4. 磁盘空间不足时
当服务器磁盘空间告急时的紧急清理：
```bash
# 查看数据卷占用情况
docker system df
```
| 类型              | 说明                                                         |
| ----------------- | ------------------------------------------------------------ |
| **Images**        | 所有镜像占用的空间，包括拉取下来的远程镜像和本地构建的镜像。镜像采用分层存储，共享相同基础层可减少实际空间占用[12,7](@ref)。 |
| **Containers**    | 运行的容器占用的空间，表示每个容器的读写层（位于`/var/lib/docker/overlay2/`）。容器停止后，读写层空间可回收[12,7](@ref)。 |
| **Local Volumes** | 容器挂载的本地数据卷空间（默认路径为`/var/lib/docker/volumes/`），用于持久化数据，生命周期独立于容器[1,12](@ref)。 |
| **Build Cache**   | 镜像构建过程中产生的缓存空间（需使用 BuildKit，Docker 18.09+）。缓存可加速后续构建，但需定期清理[12,14](@ref)。 |

```bash
# 清理未使用的数据卷
docker volume prune -f

# 如果需要更彻底的清理
docker system prune -a --volumes -f
```



## 注意事项

1. **数据安全**: 执行前确认要删除的数据卷不包含重要数据
2. **生产环境**: 在生产环境中谨慎使用，建议先查看哪些数据卷会被删除
3. **备份**: 对重要数据进行备份后再执行清理
4. **命名数据卷**: 有名称的数据卷不会被 prune 命令删除，只有匿名数据卷才会被清理

## 查看清理效果

清理前后可以通过以下命令查看效果：
```bash
# 查看所有数据卷
docker volume ls

# 查看 Docker 存储使用情况
docker system df

# 查看详细信息
docker system df -v
```

这个命令是 Docker 环境维护的重要工具，合理使用可以有效管理磁盘空间，保持 Docker 环境的整洁。