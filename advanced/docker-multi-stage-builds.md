# Docker 多阶段构建指南

[Docker 官方多阶段构建文档](https://docs.docker.com/build/building/multi-stage/)

## 什么是多阶段构建？

多阶段构建（Multi-Stage Builds）是一种 Docker 构建技巧，它允许你在 Dockerfile 中定义多个 `FROM` 指令，每个阶段都可以用不同的基础镜像和构建步骤。这种方法可以有效地减小 Docker 镜像的大小，并且使得构建过程更加高效。

### 为什么使用多阶段构建？

1. **减小镜像体积**：通过仅保留最终所需的文件和依赖，可以避免将不必要的构建工具和临时文件包含到最终镜像中。
2. **简化 Dockerfile**：多阶段构建可以将不同的构建步骤分离开，使 Dockerfile 更加清晰和易于管理。
3. **提高安全性**：只将必要的文件和依赖打包到生产环境镜像中，减少潜在的安全风险。

## 基本概念

在 Dockerfile 中，你可以使用多个 `FROM` 指令，每个指令都标志着一个新的构建阶段。你可以从一个阶段复制文件到另一个阶段，这样可以在多个阶段之间共享文件。

每个阶段都可以有独立的基础镜像，而**最终的镜像只会包含最后一个阶段的文件**。

## 示例：使用多阶段构建

下面是一个常见的多阶段构建示例，它演示了如何构建一个 Node.js 应用，并确保最终镜像只有应用代码和必需的依赖，而没有开发工具和构建文件。

### 示例 Dockerfile

```dockerfile
# 阶段 1：构建应用
FROM node:14 AS builder

# 设置工作目录
WORKDIR /app

# 将 package.json 和 package-lock.json 复制到容器中
COPY package.json package-lock.json ./

# 安装应用的依赖
RUN npm install

# 复制应用的源代码
COPY . .

# 构建应用（例如编译 TypeScript 或打包应用）
RUN npm run build

# 阶段 2：生产镜像
FROM node:14-slim

# 设置工作目录
WORKDIR /app

# 只从构建阶段复制需要的文件（比如构建后的应用代码）
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules

# 启动应用
CMD ["node", "dist/app.js"]
```

### 解析 Dockerfile

1. **阶段 1 - `builder`**：
   - 使用 `node:14` 镜像作为基础镜像，安装项目依赖，构建源代码。
   - 在这一阶段，安装所有的开发依赖（如构建工具、TypeScript 等），并将构建后的文件保存在 `/app/dist` 目录中。
2. **阶段 2 - 生产镜像**：
   - 使用 `node:14-slim` 作为基础镜像，它比 `node:14` 镜像更小，去除了很多不必要的工具。
   - 从第一阶段（`builder`）复制构建后的代码（`/app/dist`）和生产依赖（`/app/node_modules`）。
   - 只有运行时所需的文件和依赖被包含在最终镜像中，避免了开发依赖和构建工具，从而减小了镜像体积。

### 使用 `--from` 指令

- `COPY --from=builder` 用来从 `builder` 阶段复制文件到当前阶段。
- 你可以选择指定从哪个阶段复制文件，只将你需要的文件带入最终镜像。

## 多阶段构建的好处

### 1. **减小镜像体积**

通过将构建工具（如编译器、开发依赖等）保留在构建阶段，只将最终的应用和运行时依赖复制到生产镜像中，可以显著减少镜像的体积。

例如，在上面的示例中，构建工具和临时文件都不会包含在最终的镜像中，生产镜像仅包含应用代码和生产依赖。

### 2. **提高构建速度**

当 Dockerfile 中包含多个阶段时，Docker 会缓存每个阶段的构建结果。如果某个阶段没有变化，Docker 会复用该阶段的缓存，从而避免不必要的重新构建。这使得后续构建更快。

### 3. **清晰的构建步骤**

多阶段构建允许将不同的构建步骤分离到不同的阶段中。例如，安装依赖、构建应用、清理临时文件等，可以在不同的阶段进行处理，使 Dockerfile 更加易读和可维护。

### 4. **灵活性**

每个构建阶段都可以使用不同的基础镜像，使得你可以灵活选择合适的镜像。例如，你可以在构建阶段使用 `node:14` 镜像，在生产阶段使用更小的 `node:14-slim` 镜像，确保最终镜像更小。

## 高级用法：缓存共享

在多阶段构建中，Docker 会缓存每个构建阶段的结果。如果你在某个阶段没有更改文件，Docker 会重用该阶段的缓存。你可以利用这一点来优化构建过程，尤其是在依赖不经常变化的情况下。

例如，如果你只修改了应用代码，而没有修改 `package.json`，Docker 会复用安装依赖的步骤，仅重新构建应用代码部分，从而加速构建过程。

### 示例：避免重复安装依赖

```dockerfile
# 阶段 1：构建应用
FROM node:14 AS builder

WORKDIR /app

# 先安装依赖，这一步如果没有变动会被缓存
COPY package.json package-lock.json ./
RUN npm install

# 复制源代码并构建
COPY . .
RUN npm run build

# 阶段 2：生产镜像
FROM node:14-slim

WORKDIR /app

# 复制构建文件
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules

CMD ["node", "dist/app.js"]
```

- 如果你没有修改 `package.json` 和 `package-lock.json`，Docker 会跳过 `RUN npm install` 阶段，直接使用缓存的 `node_modules`，从而加快构建速度。

## 总结

- **多阶段构建** 通过将构建过程分成多个阶段，只将最终所需的文件复制到最终镜像中，从而减小了 Docker 镜像的大小。
- 每个阶段可以有不同的基础镜像和构建步骤，可以在构建过程中实现更高效的依赖安装、构建和清理。
- 通过使用 Docker 的缓存机制，可以加速构建过程，避免重复的安装和构建步骤。

多阶段构建是 Dockerfile 编写中的一项强大工具，可以帮助你构建更加高效、精简且易于维护的 Docker 镜像。

------