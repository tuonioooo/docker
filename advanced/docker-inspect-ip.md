# Docker inspect 查看容器的ip

## 基本命令

### 查看完整信息中的网络配置
```bash
docker inspect container_name
```

### 直接获取 IP 地址（最常用）
```bash
# 使用容器名称
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name

# 使用容器 ID
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_id
```

### 简化版本（默认网络）
```bash
docker inspect -f '{{.NetworkSettings.IPAddress}}' container_name
```

## 高级用法

### 查看所有网络接口的 IP
```bash
docker inspect -f '{{json .NetworkSettings.Networks}}' container_name | jq
```

### 查看特定网络的 IP
```bash
# 查看 bridge 网络的 IP
docker inspect -f '{{.NetworkSettings.Networks.bridge.IPAddress}}' container_name

# 查看自定义网络的 IP
docker inspect -f '{{.NetworkSettings.Networks.my_network.IPAddress}}' container_name
```

### 批量查看多个容器 IP
```bash
# 查看所有运行中容器的 IP
docker ps -q | xargs -I {} docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {}

# 更清晰的显示格式
docker ps --format "table {{.Names}}\t{{.Status}}" | tail -n +2 | awk '{print $1}' | xargs -I {} sh -c 'echo -n "{} - "; docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" {}'
```

## 实用示例

### 创建别名（推荐）
在 `~/.bashrc` 或 `~/.zshrc` 中添加：
```bash
alias dip="docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
```

使用方法：
```bash
dip container_name
```

### 查看详细网络信息
```bash
docker inspect container_name | grep -A 10 "NetworkSettings"
```

### 一键查看容器名称和 IP
```bash
docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name
```

## 其他相关命令

### 使用 docker ps 显示 IP（需要格式化）
```bash
# Docker 20.10+ 版本支持
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### 进入容器查看网络配置
```bash
docker exec -it container_name ip addr show
# 或
docker exec -it container_name hostname -I
```

### 查看容器的所有网络接口
```bash
docker exec -it container_name cat /etc/hosts
```

## 实际应用场景

```bash
# 1. 快速获取容器 IP 用于连接
CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my_app)
echo "App is running at: http://$CONTAINER_IP:8080"

# 2. 检查容器网络连通性
ping $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name)

# 3. 在脚本中使用
#!/bin/bash
for container in $(docker ps -q); do
    name=$(docker inspect -f '{{.Name}}' $container | cut -c2-)
    ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
    echo "$name: $ip"
done
```

这些命令可以帮助您快速获取 Docker 容器的 IP 地址，适用于不同的使用场景和需求。