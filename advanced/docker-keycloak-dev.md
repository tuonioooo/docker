# Keycloak Docker容器部署文档

## 概述

本文档描述了如何使用Docker Compose在开发环境中部署Keycloak身份认证和访问管理系统。该部署方案包含MySQL数据库和Keycloak服务两个容器，通过Docker网络进行通信。

## 架构说明

```
┌─────────────────┐    ┌─────────────────┐
│   Keycloak      │    │     MySQL       │
│   Container     │◄───┤   Container     │
│   Port: 8080    │    │   Port: 3306    │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────────────────────┘
              keycloak-network
```

## docker-compose.yml 配置

```Dockerfile
version: '3.8'

services:
  # MySQL容器
  mysql:
    container_name: mysql
    image: mysql:8.4
    command: [
      "--character-set-server=utf8mb4",
      "--collation-server=utf8mb4_unicode_ci",
      "--lower-case-table-names=1"
    ]
    ports:
      - "3306:3306"
    restart: always              # 可选, 跟随docker的启动而启动  
    volumes:
      - ./db-init:/docker-entrypoint-initdb.d
      - ./data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: 123456
      MYSQL_DATABASE: keycloak
      TZ: Asia/Shanghai
    networks:
      - keycloak-network
    restart: unless-stopped      # 自动重启，但​​排除手动停止的情况​​（最常用）
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  # Keycloak容器
  keycloak:
    container_name: keycloak
    image: quay.io/keycloak/keycloak:26.2.5-0
    depends_on:
      mysql:
        condition: service_healthy
    environment:
      # 管理员账号密码
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: admin
      KC_BOOTSTRAP_ADMIN_USERNAME: admin
      KC_BOOTSTRAP_ADMIN_PASSWORD: admin
      # 数据库配置
      KC_DB: mysql
      KC_DB_USERNAME: root
      KC_DB_PASSWORD: 123456  # 修正：应与MySQL密码一致
      # 使用容器内部端口3306，而不是主机映射端口
      KC_DB_URL: jdbc:mysql://mysql:3306/keycloak?useSSL=false&allowPublicKeyRetrieval=true
      # Quarkus配置
      KC_TRANSACTION_XA_ENABLED: "false"
      # 生产环境配置
      KC_HOSTNAME_STRICT: "false"
      KC_HOSTNAME_STRICT_HTTPS: "false"
      KC_HTTP_ENABLED: "true"
    ports:
      - "8080:8080"  # HTTP端口
    networks:
      - keycloak-network
    volumes:
      # 确保这些目录存在
      - ./keycloak/conf:/opt/keycloak/conf
      - ./keycloak/themes:/opt/keycloak/themes
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    command: 
      - start-dev
      - --hostname-strict=false     # hostname-strict = false
      - --http-enabled=true

networks:
  keycloak-network:
    driver: bridge
```

## 服务组件

### 1. MySQL数据库服务

MySQL作为Keycloak的数据存储后端，负责存储用户、角色、权限等相关数据。

#### 容器配置
- **镜像版本**: `mysql:8.4`
- **容器名称**: `mysql`
- **端口映射**: `3306:3306` (主机端口3306映射到容器端口3306)

#### 环境变量配置
| 变量名 | 值 | 说明 |
|--------|-----|------|
| `MYSQL_ROOT_PASSWORD` | `123456` | MySQL root用户密码 |
| `MYSQL_DATABASE` | `keycloak` | 自动创建的数据库名称 |
| `TZ` | `Asia/Shanghai` | 时区设置 |

#### 启动参数说明
```bash
--character-set-server=utf8mb4      # 设置字符集为utf8mb4
--collation-server=utf8mb4_unicode_ci  # 设置排序规则
--lower-case-table-names=1          # 表名小写存储和比较
```

#### 数据持久化
- **数据目录**: `./data:/var/lib/mysql` - MySQL数据文件持久化
- **初始化脚本**: `./db-init:/docker-entrypoint-initdb.d` - 数据库初始化SQL脚本

#### 初始化脚本详细说明

MySQL 自带的机制，在 ./db-init 目录中放置的所有 .sql 文件都会在首次启动时按顺序自动执行。

- ⚠️ 仅在首次启动时执行
 
```shell
# 首次启动 - 会执行初始化脚本
docker-compose up -d

# 后续启动 - 不会再执行初始化脚本
docker-compose restart
```

- 如何重新执行初始化

```shell
# 1. 停止容器
docker-compose down

# 2. 删除数据卷（重要：会丢失所有数据）
rm -rf ./data/*

# 3. 重新启动
docker-compose up -d
```

#### 健康检查
- **检查命令**: `mysqladmin ping -h localhost`
- **超时时间**: 20秒
- **重试次数**: 10次

### 2. Keycloak身份认证服务

Keycloak提供完整的身份认证和访问管理解决方案。

#### 容器配置
- **镜像版本**: `quay.io/keycloak/keycloak:26.2.5-0`
- **容器名称**: `keycloak`
- **端口映射**: `8080:8080`
- **依赖服务**: 等待MySQL容器健康检查通过后启动

#### 管理员配置

- 旧的方式已经弃用
  
| 变量名 | 值 | 说明 |
|--------|-----|------|
| `KEYCLOAK_ADMIN` | `admin` | 管理员用户名 |
| `KEYCLOAK_ADMIN_PASSWORD` | `admin` | 管理员密码 |

- 新的方式，支持环境变量、命令行配置
  
| 变量名 | 值 | 说明 |
|--------|-----|------|
| `KC_BOOTSTRAP_ADMIN_USERNAME` | `admin` | 管理员用户名 |
| `KC_BOOTSTRAP_ADMIN_PASSWORD` | `admin` | 管理员密码 |

参考：

* [https://www.keycloak.org/docs/latest/upgrading/index.html#admin-bootstrapping-and-recovery](https://www.keycloak.org/docs/latest/upgrading/index.html#admin-bootstrapping-and-recovery)

* [https://www.keycloak.org/server/configuration#_creating_the_initial_admin_user](https://www.keycloak.org/server/configuration#_creating_the_initial_admin_user)


#### 数据库连接配置
| 变量名 | 值 | 说明 |
|--------|-----|------|
| `KC_DB` | `mysql` | 数据库类型 |
| `KC_DB_USERNAME` | `root` | 数据库用户名 |
| `KC_DB_PASSWORD` | `123456` | 数据库密码 |
| `KC_DB_URL` | `jdbc:mysql://mysql:3306/keycloak?useSSL=false&allowPublicKeyRetrieval=true` | 数据库连接URL |

**重要说明**: 
- 数据库URL中使用容器名`mysql`和内部端口`3306`
- 禁用SSL连接 (`useSSL=false`)
- 允许公钥检索 (`allowPublicKeyRetrieval=true`)

#### 运行时配置
| 变量名 | 值 | 说明 |
|--------|-----|------|
| `KC_TRANSACTION_XA_ENABLED` | `false` | 禁用XA事务 |
| `KC_HOSTNAME_STRICT` | `false` | 禁用严格主机名检查 |
| `KC_HOSTNAME_STRICT_HTTPS` | `false` | 禁用严格HTTPS检查 |
| `KC_HTTP_ENABLED` | `true` | 启用HTTP协议 |

#### 启动命令参数
```bash
start-dev                    # 开发模式启动
--hostname-strict=false      # 禁用主机名严格检查
--http-enabled=true          # 启用HTTP协议
```

* [hostname-strict参数详解](./docker-keycloak-hostname-strict.md)

#### 数据卷映射
- **配置目录**: `./keycloak/conf:/opt/keycloak/conf` - Keycloak配置文件
- **主题目录**: `./keycloak/themes:/opt/keycloak/themes` - 自定义主题文件
- **时间同步**: `/etc/localtime:/etc/localtime:ro` - 与主机时间同步

## 网络配置

### keycloak-network
- **驱动类型**: bridge
- **作用**: 为MySQL和Keycloak容器提供内部网络通信

## 部署前准备

### 1. 创建必要的目录结构
```bash
mkdir -p keycloak/conf
mkdir -p keycloak/themes  
mkdir -p db-init
mkdir -p data
```

### 2. 设置目录权限
```bash
chmod -R 755 keycloak/
chmod -R 755 db-init/
chmod -R 755 data/
```

### 3. 准备初始化脚本（可选）
在`db-init`目录中放置SQL初始化脚本，容器启动时会自动执行。

## 部署步骤

### 1. 启动服务
```bash
docker-compose up -d
```

### 2. 查看服务状态
```bash
docker-compose ps
docker-compose logs -f keycloak
```

### 3. 验证部署
- **Keycloak管理控制台**: http://localhost:8080
- **管理员登录**: 用户名`admin`，密码`admin`
- **MySQL连接**: 主机`localhost`，端口`3307`

## 配置参数详解

### MySQL参数优化建议

#### 字符集配置
```bash
--character-set-server=utf8mb4
--collation-server=utf8mb4_unicode_ci
```
确保支持完整的Unicode字符集，包括emoji等特殊字符。

#### 表名配置
```bash
--lower-case-table-names=1
```
在Linux系统中强制表名小写，避免大小写敏感问题。

### Keycloak开发模式说明

开发模式 (`start-dev`) 特点：
- 自动启用HTTP协议
- 禁用生产环境安全检查
- 支持热重载配置
- 简化部署流程

**⚠️ 警告**: 开发模式仅适用于开发和测试环境，生产环境必须使用HTTPS和严格的安全配置。

## 故障排除

### 常见问题

#### 1. 数据库连接失败
- 检查MySQL容器是否正常启动
- 验证数据库连接参数是否正确
- 确认网络连通性

#### 2. Keycloak启动失败
- 查看容器日志: `docker-compose logs keycloak`
- 检查数据库健康状态
- 验证环境变量配置

#### 3. 端口冲突
- 修改端口映射配置
- 检查主机端口是否被占用

### 日志查看
```bash
# 查看所有服务日志
docker-compose logs

# 查看特定服务日志
docker-compose logs mysql
docker-compose logs keycloak

# 实时跟踪日志
docker-compose logs -f
```

## 生产环境注意事项

1. **安全配置**
   - 修改默认管理员密码
   - 启用HTTPS协议
   - 配置严格的主机名检查

2. **数据库优化**
   - 配置数据库连接池
   - 设置适当的缓存参数
   - 定期备份数据

3. **监控和日志**
   - 配置日志收集
   - 设置健康检查监控
   - 配置告警机制

4. **资源限制**
   - 设置容器内存和CPU限制
   - 配置存储容量监控

## 版本信息

- **Keycloak版本**: 26.2.5-0
- **MySQL版本**: 8.4
- **Docker Compose版本**: 3.8
