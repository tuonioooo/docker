# Docker 构建缓存指南

官方文档：

[https://docs.docker.com/build/cache/](https://docs.docker.com/build/cache/)

## 什么是构建缓存？

构建缓存是 Docker 在构建镜像时存储中间层的机制。它可以加速后续的构建过程，避免重复执行已经完成的步骤。当 Docker 构建镜像时，它会根据 `Dockerfile` 中的每一条指令生成一个镜像层。如果某个层已经存在并且没有改变，Docker 会重用这个层，从而提高构建效率。

## Docker 构建缓存如何工作？

### 缓存的使用

Docker 会根据以下规则决定是否使用缓存：

1. **相同的构建上下文：** 如果构建的上下文（包括文件内容）没有变化，Docker 会复用之前的缓存。
2. **相同的 Dockerfile 指令：** 如果 `Dockerfile` 中的指令和之前的一致，且上下文没有变化，Docker 会使用缓存。
3. **上游层的变化：** 一旦某个层发生更改，所有下游层也都需要重建。即使它们构建的内容与之前相同，也需要重新运行。这就是 Docker 构建缓存的精髓。

### 缓存的层级

Docker 在每一条 `Dockerfile` 指令之后创建一个新的层。每一层都可以缓存，当构建相同的 Dockerfile 时，如果某个层未发生变化，Docker 会重用缓存，从而节省时间。

以下是 Dockerfile 中常见的指令：

- `FROM`: 用于指定基础镜像，通常会被缓存。
- `RUN`: 用于执行命令。如果命令内容没有改变，Docker 会使用缓存。
- `COPY` 和 `ADD`: 用于将文件复制到镜像中。如果文件内容没有变化，Docker 会使用缓存。
- `ENV` 和 `ARG`: 设置环境变量和构建参数，不会影响缓存的使用。

### 如何禁用缓存

在某些情况下，可能希望跳过缓存，强制重新构建镜像。可以通过以下两种方式禁用缓存：

1. **使用 `--no-cache` 参数：**

   ```bash
   docker build --no-cache -t my-image .
   ```

   这会禁用整个构建过程中的缓存，强制 Docker 重新构建每一层。

2. **使用 `--build-arg` 参数：**

   ```bash
   docker build --build-arg CACHEBUST=$(date +%s) -t my-image .
   ```

   这种方式通过动态更改构建参数来绕过缓存。比如 `CACHEBUST` 是一个变化的时间戳，每次构建时都会不同，因此可以使某些指令跳过缓存。

## 优化构建缓存

为了充分利用缓存，通常需要优化 `Dockerfile` 中的指令顺序：

1. **将不常变更的指令放在前面：** 比如，将 `RUN apt-get update` 和 `RUN pip install` 等常见依赖安装步骤放在 `Dockerfile` 的前面，这样只有源代码变更时才会重新构建。

2. **分阶段构建：** 使用多阶段构建可以将构建的过程分为多个阶段，避免将构建过程中的临时文件添加到最终镜像中。

   例如：

   ```dockerfile
   # 第一阶段：构建阶段
   FROM node:14 AS builder
   WORKDIR /app
   COPY package.json .
   RUN npm install
   COPY . .
   
   # 第二阶段：生产阶段
   FROM node:14
   WORKDIR /app
   COPY --from=builder /app /app
   CMD ["npm", "start"]
   ```

3. **优化 `COPY` 和 `ADD` 指令：** 避免将整个上下文（包括不需要的文件）复制到镜像中，可以通过 `.dockerignore` 文件排除不必要的文件。

## 清理缓存

Docker 会在本地存储每个镜像层的缓存，但这些缓存可能会占用大量的磁盘空间。

[参考](./docker-clear-build-cache.md)


## 举例说明

当你在 Dockerfile 中执行 `RUN npm install antd` 这样的命令时，Docker 会生成一个镜像层，该层会保存所有安装的依赖包（包括 `antd`）。这个依赖包在安装过程中被下载并存储在镜像层的文件系统中，因此下一次构建时，Docker 会根据构建缓存的机制决定是否重用已经安装的依赖包。

### 具体流程

1. **第一次构建：**
   - 当你执行 `docker build` 构建镜像时，Docker 会从头开始执行 `Dockerfile` 中的每一条指令。如果 Dockerfile 中包含 `RUN npm install antd`，Docker 会执行 `npm install`，并将 `node_modules` 中的依赖包（包括 `antd`）存储在当前镜像层中。
   - 这些依赖会存储在 `/node_modules` 目录下（假设你在项目根目录中运行了 `npm install`）。
2. **缓存机制：**
   - Docker 会计算每条指令的哈希值。如果上一条 `RUN npm install antd` 指令的上下文没有变化（例如 `package.json` 或 `package-lock.json` 没有修改，且其他文件没有变化），Docker 会重用缓存中的镜像层，而不会重新执行 `npm install`。
   - 在这种情况下，Docker 会将原先的 `node_modules` 目录（以及里面的 `antd` 包）从缓存层中提取出来，作为新的镜像的一部分。
3. **如何找到缓存：**
   - **Docker层的重用：** Docker 使用每一层的哈希值来标识镜像层。当你执行 `docker build` 时，Docker 会根据当前的 `Dockerfile` 和上下文计算出每一层的哈希值。如果某一层的内容没有变化，Docker 会使用已缓存的镜像层（其中包含已安装的依赖包），而不会重新执行相同的命令。
   - **npm 缓存机制：** `npm` 在安装包时也有自己的缓存机制。`npm` 会将已下载的包缓存到本地缓存目录（通常是 `~/.npm` 或 `/root/.npm`，取决于你的运行环境）。因此，如果 Docker 镜像层中的 `node_modules` 已经包含了 `antd`，并且构建时 Docker 重用了这个层，`npm` 不需要再次从网络下载 `antd`，它会直接从缓存中读取。

### 示例场景

假设你有以下的 `Dockerfile`：

```dockerfile
FROM node:14

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install antd

COPY . .

CMD ["npm", "start"]
```

- **第一次构建：**
   Docker 会从 `package.json` 和 `package-lock.json` 中获取依赖列表，执行 `npm install antd`，并将所有依赖（包括 `antd`）安装到 `node_modules` 中。这个 `node_modules` 目录会成为镜像的一部分。
- **第二次构建：** 如果 `package.json` 和 `package-lock.json` 没有变化，Docker 会发现 `RUN npm install antd` 这条指令的上下文没有变化，因此它会复用第一次构建时生成的缓存镜像层，包括已经安装好的 `antd` 包。此时，`npm install antd` 不会再次执行，而是直接使用缓存中的 `node_modules`。

### 缓存失效的情况

缓存失效的情况通常发生在以下几种情况：

1. **`package.json` 或 `package-lock.json` 修改：**
    如果这两个文件发生变化，Docker 会认为安装的依赖发生了变化，因此会重新执行 `npm install`，从而安装新的依赖，并生成新的缓存层。
2. **其他文件的变化：**
    如果你修改了 `COPY` 指令中的源文件或目录（例如源代码），Docker 可能会重新执行相关的构建步骤，尽管 `npm install` 本身不会直接受到影响，但 Docker 仍然可能决定重新执行安装过程（取决于上下文的变化）。
3. **使用 `--no-cache` 参数：**
    如果你在构建镜像时使用了 `--no-cache` 参数，例如 `docker build --no-cache`，Docker 会跳过缓存，强制重新执行所有构建步骤，包括重新执行 `npm install antd`。

### 小结

- Docker 会缓存每个镜像层，当 `npm install antd` 这样的命令执行时，安装的包会存储在镜像层中。
- 如果上下文（如 `package.json` 或 `package-lock.json`）没有变化，Docker 会重用之前缓存的层，而不重新执行安装命令。
- `npm` 本身也有缓存机制，但 Docker 主要依赖于镜像层的缓存来决定是否重用安装的依赖包。

------

## 总结

通过合理利用 Docker 的构建缓存机制，可以显著提高构建镜像的速度。优化 `Dockerfile` 的结构，使用缓存策略，可以减少不必要的构建开销。与此同时，定期清理未使用的缓存也是维护系统性能的一个重要步骤。

------
