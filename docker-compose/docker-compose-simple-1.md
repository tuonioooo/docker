# docker Compose 示例1

Docker Compose 是一个用于定义和运行多容器应用程序的工具。它是解锁精简高效的开发和部署体验的关键。

Compose 简化了整个应用程序堆栈的控制，让您可以轻松地在一个易于理解的 YAML 配置文件中管理服务、网络和卷。然后，您只需一个命令即可从配置文件中创建并启动所有服务。

官网：

* [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
* [docker compose 加载环境变量优先级](https://docs.docker.com/compose/how-tos/environment-variables/envvars-precedence/)

## `docker-compose.yml`配置文件

```yml
version: "3"
services:
  app:
    build:
      context: . # 使用当前目录的 Dockerfile进行构建
      args:
        DEV: "true"
    image: my-fastapi-app:2.0  # 定义镜像名称和标签
    environment:
      - APP_PORT=8082  # 设置端口号
    ports:
      - "8082:8082"
    env_file: # 自动加载到Docker容器环境变量中
      - .env
    command: /bin/sh -c 'uvicorn main:app --reload --host 0.0.0.0 --port $$APP_PORT' #容器启动时执行的命令，并且会覆盖 Dockerfile 中的 CMD命令（不会执行）
    volumes:
      - ./app:/app
```

### 🔍 配置项说明

#### 1. `version: "3"`

- 指定 Docker Compose 文件的版本。
- 版本 3 是 Docker Compose 的一个稳定版本，适用于大多数场景。

#### 2. `services:`

- 定义了一个名为 `app` 的服务。
- 每个服务都会启动一个容器，您可以在其中运行应用程序。

#### 3. `build:`

- `context: .`
  - 指定构建上下文为当前目录，即 Docker Compose 会在当前目录查找 Dockerfile 进行构建。
- `args:`
  - `DEV: "true"`
    - 传递构建参数 `DEV`，值为 `"true"`，可在 Dockerfile 中使用 `ARG DEV` 进行条件判断。

#### 4. `image:`

- 指定构建完成后生成的镜像名称和标签。
- 在此示例中，镜像名称为 `my-fastapi-app`，标签为 `2.0`。

#### 5. `environment:`

- 设置环境变量 `APP_PORT`，值为 `8082`，该变量可在应用程序中使用。
- 可在`Dockerfile`通过 `${APP_PORT}` 引用、默认值写法：`${APP_PORT:-8080}`
- 如果环境变量是在`Dockerfile`中是CMD用法时，需要shell语法来识别环境变量，见：[dockerfile示例文件](#dockerfile-simple)
- 加载环境变量优先级：[参考](#加载环境变量的优先级)

#### 6. `ports:`

- 将容器的端口 `8082` 映射到主机的端口 `8082`，使得主机可以访问容器中的服务。

#### 7. `env_file:`

- 指定一个环境变量文件 `.env`，Docker Compose 会自动加载该文件中的变量到容器环境中。
- 加载环境变量优先级：[参考](#加载环境变量的优先级)

#### 8. `command:`

- 指定容器启动时执行的命令。
- 在此示例中，使用 `/bin/sh -c` 来执行 `uvicorn` 启动 FastAPI 应用。
- 注意：在 shell 中引用环境变量时，需要使用 `$$` 来转义 `$`，以避免在 Docker Compose 解析时被提前解析。
- 主要是为了公用环境变量，采用shell语法来写，静态写法：`command: uvicorn main:app --reload --host 0.0.0.0 --port 8000`
- command命令会替换`Dockerfile`中`CMD`命令

#### 9. `volumes:`

- 将当前目录的 `app` 目录挂载到容器的 `/app` 目录，允许在主机和容器之间共享文件。


### 加载环境变量的优先级

参考：[docker compose 加载环境变量优先级](https://docs.docker.com/compose/how-tos/environment-variables/envvars-precedence/)

根据Docker Compose环境变量优先级规则，我们可以总结出以下优先级公式（从高到低）：

1. `docker compose run --env VAR=value` (直接赋值)
2. `docker compose run --env VAR` (从主机环境继承)
3. `compose.yml`中的`environment:` (直接赋值)
4. `compose.yml`中的`env_file:` (直接赋值)
5. `compose.yml`中的`environment:` (引用`.env`或主机环境)
6. `compose.yml`中的`env_file:` (引用`.env`或主机环境)
7. Docker镜像中的`ENV`指令
8. `.env`文件中的值(仅当被引用时)
9. 主机环境变量(仅当被引用时)


### dockerfile-simple


```Dockerfile
# ----------------------------
# 第一阶段：基础环境  
# ----------------------------
FROM python:3.12.3-slim-bookworm AS base

# 全局环境变量，多阶段共享
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_VERSION=0.6.9 \
    LANG=C.UTF-8

# ----------------------------
# 第二阶段：构建环境   
# ----------------------------
FROM base AS builder

WORKDIR /app

COPY requirements.txt requirements-dev.txt ./

# 先检查文件是否存在，不存在则退出并报错
RUN if [ ! -f "requirements.txt" ] || [ ! -f "requirements-dev.txt" ]; then \
        echo "Error: Missing requirements file(s)"; \
        exit 1; \
    fi

# 安装系统依赖（构建+运行时）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        libffi-dev \
        curl && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# 安装现代 Python 工具链（uv）
# 安装依赖需添加 --system 参数避免自动创建虚拟环境，本身已经是容器环境无效在创建虚拟环境
RUN pip install --upgrade pip && \
    pip install uv==${UV_VERSION} && \
    uv pip install --system -r requirements.txt

# ----------------------------
# 生产阶段构建
# ----------------------------
FROM base AS production

WORKDIR /app

# 定义非 root 用户名
ARG USER_NAME=appuser
# 安全配置
RUN useradd -m ${USER_NAME} && chown -R ${USER_NAME}:${USER_NAME} /app
# 设置非 root 用户
USER ${USER_NAME}

# 从builder复制已安装的包并强制转移所有全
# 显式复制可执行文件
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/  
COPY --from=builder --chown=${USER_NAME}:${USER_NAME} /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
# 复制应用代码
COPY --chown=${USER_NAME}:${USER_NAME} . .

ENV PYTHONPATH "${PYTHONPATH}:/app"


# 轻量级的健康检查
HEALTHCHECK --interval=30s --timeout=3s \
    CMD ["sh", "-c", "curl -f http://localhost:${APP_PORT:-8080}/health || exit 1"]

EXPOSE 8000
EXPOSE 8080
EXPOSE 8082


# 设置 uvicorn 启动命令
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"] 静态写法
# 通过 sh -c 执行命令，会启动一个 shell 子进程来解析和执行命令会多一层 shell 进程开销（可以忽略不计很小）
CMD ["sh", "-c", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "${APP_PORT:8080}"]

# ----------------------------
# 第三阶段：待补充
# ----------------------------

```