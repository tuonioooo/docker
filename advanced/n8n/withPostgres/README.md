# n8n with PostgreSQL

基于 PostgreSQL 数据库的 n8n 部署配置。

## 组件说明

### init-data.sh 脚本
这个初始化脚本的主要作用是在 PostgreSQL 数据库启动时进行必要的用户设置：

1. 创建非 root 用户（由 `POSTGRES_NON_ROOT_USER` 环境变量指定）
2. 设置用户密码（由 `POSTGRES_NON_ROOT_PASSWORD` 环境变量指定）
3. 为该用户授予必要的数据库权限：
   - 数据库的所有权限
   - public schema 的 CREATE 权限

这样可以确保 n8n 使用最小权限原则访问数据库，提高系统安全性。

## 快速开始

### 环境变量配置

在启动服务之前，请先在 [`.env`](.env) 文件中配置以下环境变量：

- `POSTGRES_USER`: PostgreSQL 的超级用户
- `POSTGRES_PASSWORD`: 超级用户密码
- `POSTGRES_DB`: 数据库名称
- `POSTGRES_NON_ROOT_USER`: n8n 使用的普通用户账号
- `POSTGRES_NON_ROOT_PASSWORD`: n8n 用户密码

**重要：** 请确保修改默认的用户名和密码！

### 启动服务

在当前目录执行以下命令启动服务：

```bash
docker-compose up -d
```

### 停止服务

执行以下命令停止服务：

```bash
docker-compose stop
```