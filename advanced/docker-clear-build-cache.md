# Docker 清理缓存

## 第一步：查看当前状况

**查看整体磁盘使用情况：**
```bash
docker system df
```

```
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          11        8         5.461GB   861.3MB (15%)
Containers      9         7         24.71MB   45.46kB (0%)
Local Volumes   0         0         0B        0B
Build Cache     33        0         3.096GB   3.096GB
```

**查看详细信息（可选）：**
```bash
docker system df -v
```

这会显示镜像、容器、本地卷和构建缓存各占用多少空间。


## 第二步：分析并选择清理策略

根据查看结果，判断哪些占用空间最多：
- Build Cache 占用大 → 重点清理构建缓存
- Images 占用大 → 重点清理镜像
- Containers 占用大 → 重点清理容器

## 第三步：渐进式清理

**温和清理（推荐首选）：**
```bash
# 清理未使用的构建缓存
docker builder prune

# 清理停止的容器、未使用的网络和悬空镜像
docker system prune
# 清理停止的容器、未使用的网络和悬空镜像 -f 参数的含义是 --force，表示强制执行，跳过确认提示。
docker system prune -f
```

会弹出如下警告提示信息：

```
# 输入y，立即进行删除
WARNING! This will remove all dangling build cache. Are you sure you want to continue? [y/N]
```

**查看清理效果：**
```bash
docker system df
```

## 第四步：深度清理（如果需要）

如果空间还不够，继续：

```bash
# 清理所有未使用的镜像
docker image prune -a

# 清理所有构建缓存（包括正在使用的）
docker builder prune -a
```

**再次查看效果：**
```bash
docker system df
```

## 第五步：终极清理（谨慎使用）

如果确实需要释放最大空间：
```bash
# 警告：这会删除所有未使用的资源
docker system prune -a

# 如果连数据卷也要清理（非常危险）
docker system prune -a --volumes
```

## 完整的一键脚本

```bash
#!/bin/bash
echo "=== Docker 缓存清理 ==="
echo "清理前状态："
docker system df
echo ""

echo "开始清理未使用的资源..."
docker system prune -f

echo ""
echo "清理后状态："
docker system df
echo ""
echo "清理完成！"
```

**优势：** 这种渐进式方法让你能够控制清理程度，避免意外删除重要资源，同时能清楚看到每一步的效果。