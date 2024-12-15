# Docker Compose 和 docker-compose 区别

主要体现在实现方式、工具版本以及未来的支持策略上。以下是详细的对比：

## 1. 名称及实现方式

### `Docker Compose`

* **实现方式**：
  是 Docker 的内置插件，从 Docker 1.27.0 开始集成到 Docker CLI 中。

* **命令调用**：
  使用 docker compose（注意中间有空格）。

   ```shell
   docker compose up
   ```

* 现代化实现：
  基于 Go 语言实现，与 Docker CLI 共享二进制文件，性能更高，安装更简单。

### `docker-compose`

* 实现方式：
  是一个独立工具，最初以 Python 编写并作为 Docker 的扩展工具存在。
* 命令调用：
  使用 docker-compose（连字符连接）。

  ```shell
  docker-compose up
  ```

## 2. 安装与兼容性

### `Docker Compose`

* 安装：
  通常默认随现代版本的 Docker Desktop 或 Docker Engine 安装，无需单独安装。
* 查看版本：

```shell
docker compose version
```

* 兼容性：
  从 Docker 20.10+ 开始支持。

### `docker-compose`

* 安装：
  需要单独下载安装，通常通过 pip 或下载二进制文件。
  安装示例（Linux）：

```shell
sudo curl -L "https://github.com/docker/compose/releases/download/v2.x.x/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

* 兼容性：
  可用于旧版本 Docker，适合尚未升级的系统。

## 3. 功能与未来支持

### `Docker Compose`

* 功能：
  与 Docker CLI 深度集成。
  支持新特性，例如 Compose V2 文件格式。
  性能优化更好，推荐用于新项目。
* 未来支持：
  是 Docker 官方重点发展的工具，docker-compose 将逐步被淘汰。

### `docker-compose`

* 功能：
  提供与 Docker Compose 类似的功能，但不支持部分新特性。
  不适用于最新的 Docker Compose 文件规范 V2+。
* 未来支持：
  逐步被弃用，官方建议迁移到 docker compose。

## 4. 实用对比

| 特性     | Docker Compose   | docker-compose   |
|--------|------------------|------------------|
| 调用方式   | `docker compose` | `docker-compose` |
| 实现语言   | Go               | Python           |
| 安装方式   | 默认随 Docker 安装    | 需要单独安装           |
| 支持的新特性 | 完全支持             | 部分不支持            |
| 官方推荐   | 是                | 否                |
| 未来发展   | 持续支持与优化          | 被逐步弃用            |

## 5. 如何迁移到 Docker Compose

如果之前使用的是 docker-compose，只需：

确保 Docker 版本是 20.10 或更高。
直接将 docker-compose 命令替换为 docker compose。
测试并适配新的 Compose V2 文件格式（如果需要）。