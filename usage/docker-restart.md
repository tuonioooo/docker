# Docker 重启策略

Docker 和 Docker Compose 的**默认重启策略是 `no`**，也就是**不重启**。

## 各种情况下的默认策略

### 1. docker run 命令
```bash
# 默认情况
docker run your-image
# 等同于
docker run --restart=no your-image
```

### 2. Docker Compose
```yaml
services:
  app:
    image: your-image
    # 默认 restart: "no" (不重启)
```

### 3. Dockerfile
```dockerfile
# Dockerfile 中无法设置重启策略
# 重启策略只能在运行时设置
```

## 所有重启策略对比

### `no` (默认)
```yaml
restart: "no"  # 注意要用引号，因为 no 是 YAML 关键字
```
- ✅ 任何情况下都不重启
- ❌ 进程崩溃后容器停止

### `always`
```yaml
restart: always
```
- ✅ 总是重启，除非手动停止
- ✅ Docker 守护进程重启后也会重启
- ❌ 即使手动停止也会重启（除非 `docker stop`）

### `on-failure`
```yaml
restart: on-failure
# 或指定最大重试次数
restart: on-failure:3
```
- ✅ 只在非正常退出时重启（退出码非0）
- ❌ 正常退出（退出码0）不重启

### `unless-stopped`
```yaml
restart: unless-stopped
```
- ✅ 总是重启，除非手动停止
- ❌ 手动停止后不会重启

## 实际测试各种策略

### 默认策略测试
```bash
# 创建一个会崩溃的容器
docker run --name test-default alpine sh -c "sleep 5; exit 1"

# 5秒后容器退出，不会重启
docker ps -a  # 状态显示 Exited (1)
```

### 对比其他策略
```bash
# always 策略
docker run --restart=always --name test-always alpine sh -c "sleep 5; exit 1"
# 5秒后退出，然后立即重启，无限循环

# on-failure 策略
docker run --restart=on-failure:3 --name test-failure alpine sh -c "sleep 5; exit 1"
# 5秒后退出，重启，最多重试3次

# unless-stopped 策略
docker run --restart=unless-stopped --name test-unless alpine sh -c "sleep 5; exit 1"
# 5秒后退出，然后重启，直到手动停止
```

## 生产环境建议

```yaml
services:
  crawl4ai:
    build: .
    restart: unless-stopped  # 推荐：意外崩溃重启，手动停止不重启
    
  redis:
    image: redis:7-alpine
    restart: unless-stopped  # 同样策略保持一致
```

### 不同环境的策略选择

**开发环境：**
```yaml
restart: "no"  # 方便调试，崩溃后不重启
```

**测试环境：**
```yaml
restart: on-failure:3  # 允许一定次数的重试
```

**生产环境：**
```yaml
restart: unless-stopped  # 平衡自动恢复和手动控制
```

## 验证当前策略

### 查看容器的重启策略
```bash
# 查看运行中的容器
docker inspect <container-name> | grep -A 3 "RestartPolicy"

# 输出示例：
# "RestartPolicy": {
#     "Name": "unless-stopped",
#     "MaximumRetryCount": 0
# }
```

### Docker Compose 中查看
```bash
docker-compose config
# 会显示完整的配置，包括默认值
```

## 总结

**关键信息：**
- **默认策略**: `no` (不重启)
- **推荐生产策略**: `unless-stopped`
- **开发调试**: 保持默认 `no`
- **如果不设置**: 容器崩溃后就停止，需要手动重启
