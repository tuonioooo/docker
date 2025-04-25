# Docker Dockerfile Ptyhon实战配置之多阶段构建-2

本示例配置以 `python:3.12-slim-bookworm` 为基础镜像构建Docker镜像

官方文档：

* [多阶段构建](https://docs.docker.com/build/building/multi-stage/)
* [构建最佳实践](https://docs.docker.com/build/building/best-practices/) （重点阅读 "Sort multi-line arguments" 部分）
* [Shell 和 exec 形式](https://docs.docker.com/reference/dockerfile/#exec-form)


## 完整Dockerfile

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

# ENV设置的环境变量，CMD指令可以识别
# 设置默认端口号（无法在构建时修改），支持运行时通过 -e 或 docker-compose.yml进行覆盖



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

```

### 第一阶段基础镜像

```Dockerfile
# 使用官方 Python 基础镜像（推荐 slim 版本以减少体积）
FROM python:3.12.3-slim-bookworm AS base

# 全局环境变量，多阶段共享
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_VERSION=0.6.9 \
    LANG=C.UTF-8
```

具体选择哪个版本，请看：[Docker Python镜像 TAG 说明](../install/docker-install-python-tags.md)

ENV 设置的环境变量默认不会自动跨阶段共享、每个阶段都需要独立设置


1. **`PYTHONUNBUFFERED=1`**

- **作用**：禁用 Python 的标准输出缓冲（stdout/stderr）。
- **默认值**：PYTHONUNBUFFERED=0（即启用缓冲）。
- **效果**：
  - 日志和打印输出会**立即显示**（不等待缓冲区满），适合容器或实时日志场景。
  - 避免日志延迟，尤其在 Docker 或 CI/CD 环境中非常有用。
- **建议**：在 Docker 环境中，通常设置为 1，因为你可能希望日志即时显示，避免等待缓冲区写满。

------

2. **`PYTHONDONTWRITEBYTECODE=1`**

- **作用**：禁止 Python 生成 `.pyc` 字节码缓存文件。
- **默认值**：PYTHONDONTWRITEBYTECODE=0（即启用 .pyc 文件的生成）。
- **效果**：
  - 避免在容器或临时环境中生成冗余的 `__pycache__` 目录。
  - 减少磁盘写入，提升性能（但可能略微增加启动时间，因为没有 .pyc 文件，Python 需要重新解析源代码）。
- **建议**：在 Docker 和类似环境中，建议设置为 1，避免多余的文件生成，尤其是在容器中，减少磁盘空间占用。

------

3. **`PIP_NO_CACHE_DIR=1`**

- **作用**：禁用 pip 的缓存功能。
- **默认值**：PIP_NO_CACHE_DIR=0（即启用缓存）。
- **效果**：
  - 安装包时不会缓存到本地（如 `~/.cache/pip`），节省磁盘空间。
  - 适合一次性构建的容器环境，避免缓存污染。
- **建议**：对于容器化应用，建议设置为 1，避免缓存的 pip 包影响镜像体积，并减少构建时的磁盘空间消耗。

------

4. **`PIP_DISABLE_PIP_VERSION_CHECK=1`**

- **作用**：禁止 pip 检查自身版本更新。
- **效果**：
  - 跳过每次运行时检查 pip 新版本的网络请求。
  - 减少构建时间，避免因网络问题导致的延迟。
- **建议**：为了加速构建过程并避免不必要的网络请求，建议设置为 1，尤其在容器或自动化构建流程中。

------

5. **`UV_VERSION=0.2.0`**

- **作用**：指定 `uv`（Rust 编写的 Python 工具链）的版本。
- **效果**：
  - uv 是一个高效的工具链，用于快速安装和管理 Python 项目依赖。通过指定版本，可以确保工具链版本的一致性。
  - 如果 uv 版本与项目的要求不匹配，可能会导致构建问题，因此指定版本是确保构建稳定性的好做法。
- **默认值**：此变量没有默认值，具体值需要根据项目需求指定。
- **建议**：推荐指定特定版本的 uv，以确保工具链版本的兼容性和一致性。可以根据项目需求选择稳定的版本（如 0.6.9 等）。

------

#### 总结

这些变量通常用于 ​​容器化部署​​ 或 ​​CI/CD 流水线​​，目的是：

* 如果是本地开发环境，部分变量（如 PYTHONDONTWRITEBYTECODE）可能会影响调试体验，需根据实际需求调整。  
* 减少冗余文件​​（如 .pyc、pip 缓存）。  
* 提升日志实时性​​（无缓冲输出）。  
* 避免不必要的网络请求​​（如 pip 版本检查）。   
* 固定工具版本​​（确保环境一致性）。

### 第二阶段：构建环境

```Dockerfile
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
```

安装相关的依赖包，并清除缓存


### 第三阶段：生产环境

```Dockerfile
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

# ENV设置的环境变量，CMD指令可以识别
# 设置默认端口号（无法在构建时修改），支持运行时通过 -e 或 docker-compose.yml进行覆盖



# 轻量级的健康检查
HEALTHCHECK --interval=30s --timeout=3s \
    CMD ["sh", "-c", "curl -f http://localhost:${APP_PORT:-8080}/health || exit 1"]

EXPOSE 8000
EXPOSE 8080
EXPOSE 8082


# 设置 uvicorn 启动命令
# 通过 sh -c 执行命令，会启动一个 shell 子进程来解析和执行命令会多一层 shell 进程开销
# CMD ["sh", "-c", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "${PORT}"]

# 
CMD ["sh", "-c", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "${APP_PORT:8080}"]

```

在 Dockerfile 中，`CMD` 指令有两种形式：

1. **Shell 形式**：`CMD command param1 param2`
2. **Exec 形式**：`CMD ["executable", "param1", "param2"]`

Shell 形式会通过 `/bin/sh -c` 启动命令，这样可以正确地解析环境变量。而 Exec 形式不会调用 shell，因此无法解析环境变量。

例如，以下两种写法的效果不同：

```dockerfile
# Shell 形式
CMD uvicorn main:app --host 0.0.0.0 --port ${PORT}
# Exec 形式
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "${PORT}"]
```

在 Shell 形式中，`${PORT}` 会被正确解析为环境变量的值；而在 Exec 形式中，`${PORT}` 会被当作字面量字符串处理，导致启动失败。

详见：[https://docs.docker.com/reference/dockerfile/#exec-form](https://docs.docker.com/reference/dockerfile/#exec-form)