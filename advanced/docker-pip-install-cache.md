#  Docker pip install `--no-cache-dir`

官方文档：

[https://pip.pypa.io/en/stable/topics/caching/#disabling-caching](https://pip.pypa.io/en/stable/topics/caching/#disabling-caching)


`pip install --no-cache-dir` 是一个常用的选项，它告诉 `pip` 在安装 Python 包时 **不使用缓存**，并且 **不缓存安装包文件**（如 `.tar.gz` 或 `.whl` 文件），从而避免这些缓存文件被保留在镜像中。这个选项的使用对于减小 Docker 镜像体积非常有帮助，特别是在构建镜像时，避免将不必要的缓存文件包含在镜像层中。



### 具体解释

在默认情况下，`pip` 会将下载的包缓存到本地缓存目录中（通常是 `~/.cache/pip` 或 `/root/.cache/pip`）。这样做的目的是提高后续安装速度，因为如果你再次安装相同的包，`pip` 会直接从缓存中读取包，而不是重新下载。然而，缓存的包文件通常并不需要包含在 Docker 镜像中，这些缓存文件会导致镜像体积增大。

#### 使用 `--no-cache-dir`

当你在 Dockerfile 中执行 `pip install` 时，可以加入 `--no-cache-dir` 选项，避免缓存文件被存储在镜像中。这样可以确保只有安装后的包被保留在镜像中，而不会有任何额外的缓存文件。

**示例：**

```dockerfile
FROM python:3.9

WORKDIR /app

COPY requirements.txt .

# 安装依赖并避免缓存
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

在这个例子中，`pip install --no-cache-dir` 会确保在安装依赖时不缓存任何下载的包文件，避免这些文件被包含在镜像层中，从而减小镜像的体积。

### 缓存存储的默认路径

```Linux
~/.cache/pip
```

```Mac
~/Library/Caches/pip
```

```Windows
%LocalAppData%\pip\Cache
```

### 为什么 `--no-cache-dir` 重要？

1. **减小镜像体积：**
    安装过程中，`pip` 下载的包会存储在缓存目录中，而这些包并不需要被包含在最终的镜像中。使用 `--no-cache-dir` 可以避免将这些缓存文件添加到镜像层中。
2. **避免不必要的文件：**
    缓存文件并不是最终运行环境所需要的，通常只是为了加速后续的安装过程。它们会占用额外的存储空间，增加 Docker 镜像的大小，而这对最终的生产镜像是没有任何意义的。

### 总结

- **默认行为：** `pip install` 会将下载的包文件缓存到本地，以便未来复用。
- **使用 `--no-cache-dir`：** 该选项可以防止 `pip` 缓存包文件，从而避免它们被包含在 Docker 镜像层中，减小镜像体积。
- **推荐做法：** 在 Dockerfile 中使用 `pip install --no-cache-dir` 以确保生成的镜像尽可能小，避免缓存文件的冗余。

