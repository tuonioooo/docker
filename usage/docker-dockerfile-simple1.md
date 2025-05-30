# Docker Dockerfile Ptyhon实战配置-1

本示例配置以 `python:3.12-slim-bookworm` 为基础镜像构建Docker镜像

官方文档：

* [多阶段构建](https://docs.docker.com/build/building/multi-stage/)
* [构建最佳实践](https://docs.docker.com/build/building/best-practices/) （重点阅读 "Sort multi-line arguments" 部分）


## 完整Dockerfile

```Dockerfile
# 使用官方 Python 基础镜像（推荐 slim 版本以减少体积）
FROM python:3.12-slim-bookworm AS base

# 全局环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_VERSION=0.6.9 \
    LANG=C.UTF-8

# 安装系统依赖（按需调整）并清理缓存以减小镜像体积
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev curl && \
    rm -rf /var/lib/apt/lists/*

# 安装现代 Python 工具链（uv + poetry）
RUN pip install --upgrade pip && \
    pip install uv==${UV_VERSION}
    
# 设置工作目录
WORKDIR /app

# ----------------------------
# 构建阶段（安装依赖）
# ----------------------------
FROM base AS builder

# 复制依赖声明文件（支持 pyproject.toml 和 requirements.txt）
COPY pyproject.toml poetry.lock* requirements*.txt ./ 

# 使用 uv 快速安装依赖（生产环境）
RUN uv pip install -r requirements.txt

# 可选：开发依赖分层安装
ARG DEV=false
RUN if [ "$DEV" = "true" ]; then \
    uv pip install -e .[dev]; \
    fi

# ----------------------------
# 运行时阶段
# ----------------------------
FROM base AS runtime

# 从构建阶段复制已安装的包
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /app . 

# 复制上下文的应用代码到WORKDIR内
COPY . .

# 设置 Python 路径（将工作目录放到Python的搜索路径中）
ENV PYTHONPATH "${PYTHONPATH}:/app"

# 安全配置
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# 服务端口
EXPOSE 8080

# 启动命令（根据实际框架调整）
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]

```

### 基础镜像

```Dockerfile
# 使用官方 Python 基础镜像（推荐 slim 版本以减少体积）
FROM python:3.12-slim-bookworm AS base
```

具体选择哪个版本，请看：[Docker Python镜像 TAG 说明](../install/docker-install-python-tags.md)

### 全局环境变量

```Dockerfile
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_VERSION=0.6.9 \
    LANG=C.UTF-8
```
ENV 设置的环境变量默认不会自动跨阶段共享，**需要通过继承关系来实现共享**

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


### 安装系统依赖

```Dockerfile
# 安装系统依赖（按需调整）并清理缓存以减小镜像体积
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        libffi-dev \
        curl \
        && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    pip install --upgrade pip && \
    python --version

# 安装现代 Python 工具链（uv + poetry）
RUN pip install --upgrade pip && \
    pip install uv==${UV_VERSION}
    
# 设置工作目录
WORKDIR /app
```

#### 命令解释

* apt-get update：更新包索引。
* apt-get install -y --no-install-recommends：
  * ​​-y​​：自动回答“yes”，避免安装过程中需要手动确认。
  * 安装所需的包并避免安装推荐的额外包，以减小镜像大小。
* build-essential​​：包含 GCC、make 等编译工具链（编译 Python C 扩展必备）。
* ​​libpq-dev​​：PostgreSQL 客户端库的开发文件（用于 psycopg2 等 Python 数据库驱动）。
* libffi-dev：安装libffi的开发文件，某些Python包（如cryptography）需要这个库
* rm -rf /var/lib/apt/lists/*：删除 apt 的索引缓存，减少层大小。
* apt-get clean：清理 apt 包管理器下载的临时缓存，进一步减小镜像体积。它会删除下载的 .deb 包文件，避免它们被保留在镜像中。

#### 说明

* **减少不必要的层（Layer）**

  - 每一个 `RUN` 命令都会生成一个新的层，过多的 `RUN` 命令会导致镜像过大。合并多个 `RUN` 命令，减少镜像层的数量。

* **使用 `apt-get clean`**

  - 在安装完系统依赖后，执行 `apt-get clean` 以减少镜像大小。因为 `apt-get update` 会下载很多临时文件，安装后应该删除这些文件。
  - 它会删除 /var/cache/apt/archives/ 目录中的所有 .deb 包缓存文件，这些文件是 apt-get 安装软件包时下载的包。
  - 这些缓存文件通常是安装完软件包后不再需要的，删除它们可以有效**减少镜像的体积**。

* **减少镜像体积**

  - 使用 `--no-install-recommends` 选项来避免安装不必要的包。

* **rm -rf /var/lib/apt/lists/***:

  - 这个命令会删除 `/var/lib/apt/lists/` 目录中的包索引文件。
  - 包索引文件是 apt-get update 时下载的，包含了关于可用包的信息（如包的版本、依赖关系等）。
  - 删除这些文件会导致以后无法通过 apt-get update 命令直接从缓存获取包的索引，通常在安装软件包后删除它们有助于**减少镜像体积**。

* **优化 Python 安装依赖 `--no-cache-dir`**

  - [优化安装依赖](../advanced\docker-pip-install-cache.md)
  - [docker缓存构建原理](../advanced/docker-build-cache.md)


### 构建阶段（安装依赖）

```Dockerfile
# ----------------------------
# 构建阶段（安装依赖）
# ----------------------------
FROM base AS builder

# 复制依赖声明文件（支持 pyproject.toml 和 requirements.txt）
COPY pyproject.toml poetry.lock* requirements*.txt ./ 

# 使用 uv 快速安装依赖（生产环境）
RUN uv pip install -r requirements.txt

# 可选：开发依赖分层安装
ARG DEV=false
RUN if [ "$DEV" = "true" ]; then \
    uv pip install -r requirements-dev.txt; \
    fi

```

#### **`FROM base AS builder`**

在 Docker 多阶段构建中，重复定义 `FROM ... AS` 的目的是为了​​明确划分不同的构建阶段​​，隔离实现镜像精简，每个阶段可以独立选择基础镜像、安装依赖和执行任务。以下是具体原因：

1. **阶段独立性**

每个 `FROM` 指令会创建一个 全新的构建阶段 ，前一个阶段的文件系统、环境变量和操作不会自动继承到下一个阶段

例如：

  ```dockerfile
  FROM python:3.12-slim AS builder  # 阶段1：编译依赖
  RUN pip install --user -r requirements.txt
  
  FROM python:3.12-slim AS runtime  # 阶段2：运行环境
  COPY --from=builder /root/.local /root/.local
  ```

这里 `builder` 和 `runtime` 是两个完全隔离的环境，`runtime` 阶段不会包含 `builder` 阶段安装的临时工具（如编译器）。

------

2. **优化镜像体积**

- 多阶段构建的核心目的是​​仅保留最终需要的文件​​。通过分阶段操作，可以丢弃中间阶段的冗余内容（如编译工具链、缓存文件）。
- 如果只定义一个阶段，所有中间文件都会保留在最终镜像中，导致体积臃肿。

------

3. **灵活的基础镜像选择**

* 不同阶段可能需要不同的基础镜像。例如：
  * ​​构建阶段​​：使用包含编译工具的镜像（如 golang:1.21）。
  ​​* 运行阶段​​：使用极简镜像（如 alpine 或 distroless）。
* 单阶段构建无法实现这种灵活性

------

4. **代码可读性与维护性**

* 显式命名阶段（如 AS builder）可以让 Dockerfile 更易读，便于后续维护或扩展。
* 例如，后续可以通过 --target=builder 参数单独构建某个阶段

```bash
docker build --target builder -t myapp-builder .
```

------

5. **总结**

重复定义 `FROM ... AS` 是 Docker 多阶段构建的**核心设计**，目的是通过阶段隔离实现镜像精简、安全性和灵活性。如果仅定义一个阶段，将失去多阶段构建的所有优势


#### `pip install -e .[dev] 依赖的作用`

- **开发工具链**：

  - `pytest`：单元测试框架。
  - `black`/`autopep8`：代码风格自动化和格式化。
  - `ipdb`：调试工具（类似 `pdb`，但支持 IPython 增强）。
  - `pylint`：代码质量检查（如命名规范、未使用变量等）。

- **安装方式**：
  使用 `pip` 安装开发依赖（需指定 `dev` 组）：

  ```bash
  pip install -e ".[dev]"  # 从本地安装（开发模式）
  或
  pip install package-name[dev]  # 从 PyPI 安装时
  ```

### 运行时阶段


#### `COPY . .`

在 Dockerfile 中使用 `COPY . .` 语句时，两个点（`.`）的含义如下：

- **第一个点 (`.`)**：表示**源路径**，即从 Docker 构建上下文（通常是当前的目录）中复制文件或目录。在构建过程中，Docker 会将当前目录（即 Dockerfile 所在目录）作为构建上下文，除非通过 `docker build` 命令显式指定其他目录。
- **第二个点 (`.`)**：表示**目标路径**，即复制到镜像中的路径。`COPY . .` 语句中的第二个点表示将源路径中的内容复制到镜像中的当前工作目录。在 Dockerfile 中，你设置了 `WORKDIR /app`，因此第二个点表示将源文件复制到镜像中的 `/app` 目录。

**具体举例说明：**

**假设你的项目结构是：**

```bash
/project
  ├── Dockerfile
  ├── app/
  ├── requirements.txt
  └── .dockerignore
```

- 构建上下文是 `/project`，即你运行 `docker build` 命令的目录。
- 你在 Dockerfile 中写了 `COPY . .`，这意味着：
  - **源路径**：当前构建上下文（`/project` 目录），也就是你在构建时指定的目录。
  - **目标路径**：镜像中的 `/app` 目录（因为你之前设定了 `WORKDIR /app`），将构建上下文的内容复制到这个目录。

**结果：**

- `/project` 目录中的所有文件和子目录（除了 `.dockerignore` 中指定的文件）都会被复制到镜像中的 `/app` 目录。

**注意：**

- `.dockerignore` 文件可以控制哪些文件不会被复制到镜像中。它的作用类似于 `.gitignore`，可以避免将不需要的文件（如构建文件、日志等）复制到镜像中，从而减小镜像体积。

例如，`.dockerignore` 文件中可能包含：

```
**/*.pyc
__pycache__
.git
```

这将确保 `.pyc` 文件、`__pycache__` 目录和 `.git` 文件夹不会被复制到镜像中。

------

**小结：**

- `COPY . .` 语句将当前目录（构建上下文）的所有内容复制到镜像中的当前工作目录（`WORKDIR`）下。
- 第一个点是源路径，第二个点是目标路径。


#### `ENV PYTHONPATH "${PYTHONPATH}:/app"`

在 Dockerfile 中，通常把应用代码拷贝到镜像的 `/app` 目录下（通过 `WORKDIR /app`）。如果不显式把 `/app` 加入 `PYTHONPATH`，当你以模块方式运行（如 `uvicorn main:app`）或在其他目录调用 Python 时，Python 并不总是会把 `/app` 作为模块根目录。这时就可能出现 `ModuleNotFoundError`。

**原理：**

是在容器内设置（或扩展）Python 的模块搜索路径，使得 `/app` 目录始终被加入到 Python 启动时的 `sys.path` 列表中。这样，无论你在何处运行 `python`，都可以直接通过 `import your_module` 来加载 `/app` 下的代码，而不必安装成 package 或手动修改 `sys.path`。

**示例：**

```bash
# 启动容器后，如果不设置 PYTHONPATH：
$ python -c "import main"
Traceback (most recent call last):
  ModuleNotFoundError: No module named 'main'
```

而有了

```dockerfile
ENV PYTHONPATH "${PYTHONPATH}:/app"
```

则 `/app` 会被加入到 `sys.path`，保证 `import main` 或者 `from your_package import ...` 都能正常找到代码。

**小结**

- **作用**：确保容器内无论何时何地 `/app` 都在 Python 的模块搜索路径里。
- **好处**：
  - 避免在代码里硬编码 `sys.path.append()`。
  - 以模块方式启动（`uvicorn main:app`、`python -m your_package`）时不会因找不到模块而报错。

#### 安全配置

在 Dockerfile 中配置用户和权限的步骤，如：

```dockerfile
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser
```

是一个**最佳实践**，并且对于大多数生产环境来说是非常推荐的，尤其是考虑到安全性方面的原因。

**为什么配置用户和权限是有必要的：**

1. **避免使用 root 用户运行应用**：
   - Docker 容器默认以 `root` 用户运行，`root` 用户拥有对系统的完全控制权限。如果你的容器内的应用存在安全漏洞，攻击者可以利用容器中的 `root` 用户进行更严重的操作（如获取容器外的资源或控制主机）。
   - 通过在 Dockerfile 中创建一个普通用户（如 `appuser`），并将应用切换到该用户运行，可以有效地**限制容器内应用的权限**，即使容器被攻击，攻击者也只能获得该普通用户的权限，减少潜在的安全风险。
2. **遵循最小权限原则（Principle of Least Privilege）**：
   - 在安全领域，最小权限原则意味着给程序或用户最少的权限，只允许其执行必要的操作。将容器中的应用切换到非 `root` 用户，可以确保即使应用存在漏洞，攻击者也无法获得不必要的权限。
3. **增强容器隔离性**：
   - 即使容器在运行时暴露了安全漏洞，非 `root` 用户的容器更难被用来突破容器的隔离层，对宿主系统进行攻击。
4. **容器生产环境的标准做法**：
   - 在很多企业和安全合规性较高的生产环境中，**强制执行容器应用以非 `root` 用户运行**已成为行业标准。例如，某些云平台和容器扫描工具会检查容器是否以 `root` 用户运行，如果是 `root` 用户，可能会标记为不符合安全标准。
5. **目录权限管理**：
   - 通过 `chown -R appuser:appuser /app`，可以确保 `/app` 目录和其中的所有文件的拥有者是 `appuser`，避免在容器内出现权限不一致的问题。通常，`root` 用户可能会拥有 `/app` 中的文件权限，这样当切换到 `appuser` 后，`appuser` 无法访问这些文件。通过修改文件权限，确保容器内应用的正常运行。


## 其他优化Docker镜像的方案

* [https://www.toutiao.com/article/7486394236926018098/](https://www.toutiao.com/article/7486394236926018098/)

