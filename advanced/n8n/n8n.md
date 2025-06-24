# n8n 工作流自动化平台

## 简介
n8n 是一个功能强大的工作流自动化平台，可以帮助您连接各种服务和系统，实现数据流的自动化处理。

- 官方网站：https://github.com/n8n-io/n8n
- Docker镜像：https://hub.docker.com/r/n8nio/n8n
- 个人obsidian笔记

## 快速开始

### 方式一：使用 Docker 直接运行（带隧道模式）不适用于生产环境

```bash
# 创建持久化数据卷
docker volume create n8n_data

# 运行 n8n 容器
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n \
  start --tunnel
```

[docker-compose.yml示例](./docker-compose.yml)

说明：
- `-p 5678:5678`: 映射容器端口到主机
- `-v n8n_data:/home/node/.n8n`: 数据持久化
- `--tunnel`: 启用隧道模式，适用于开发环境
- `docker-compose`，如果采用自动创建卷，会在卷的前面加一个容器的名称前缀

### 方式二：使用 PostgreSQL 的 Docker Compose 部署

n8n 官方提供了一个完整的使用 PostgreSQL 数据库的 Docker Compose 配置模板，适合生产环境使用：

- 配置模板地址：https://github.com/n8n-io/n8n-hosting/blob/main/docker-compose/withPostgres/docker-compose.yml
- [已下载模版](./withPostgres/docker-compose.yaml)

## 访问方式

部署完成后，可以通过以下地址访问 n8n：
- 本地访问：http://localhost:5678
- 默认用户名：admin@example.com
- 默认密码：请查看容器日志获取

