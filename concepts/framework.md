# 架构

Docker 架构是基于客户端-服务器模式的，其中包括多个关键组件，确保容器化应用的高效构建、管理和运行。

Docker 的架构设计使得开发者能够轻松地将应用程序与其所有依赖封装在一个可移植的容器中，并在不同的环境中一致地运行。

Docker 使用客户端-服务器 (C/S) 架构模式，使用远程 API 来管理和创建 Docker 容器。

Docker 容器通过 Docker 镜像来创建。

容器与镜像的关系类似于面向对象编程中的对象与类。

| Docker | 面向对象 |
|--------|------|
| 容器     | 对象   |
| 镜像     | 类    |

### Docker 架构示意图

![](../assets/concepts/framework.webp)

### Docker 架构的工作流程

+ **构建镜像**：使用 `Dockerfile` 创建镜像。
+ **推送镜像到注册表**：将镜像上传到 Docker Hub 或私有注册表中。
+ **拉取镜像**：通过 `docker pull` 从注册表中拉取镜像。
+ **运行容器**：使用镜像创建并启动容器。
+ **管理容器**：使用 Docker 客户端命令管理正在运行的容器（例如查看日志、停止容器、查看资源使用情况等）。
+ **网络与存储**：容器之间通过 Docker 网络连接，数据通过 Docker 卷或绑定挂载进行持久化。

接下来让我们深入探讨 Docker 的核心组件及其工作机制。

### 1、**Docker 客户端（Docker Client）**

Docker 客户端是用户与 Docker 守护进程交互的命令行界面（CLI）。它是用户与 Docker 系统的主要交互方式，用户通过 Docker CLI
发出命令，这些命令被发送到 Docker 守护进程，由守护进程执行相应的操作。

+ **功能**：允许用户使用命令与 Docker 守护进程通信，如创建容器、构建镜像、查看容器状态等。
+ **交互方式**：Docker 客户端与 Docker 守护进程之间通过 REST API 或 Unix 套接字通信。常用的命令行工具是 `docker`
  ，通过它，用户可以发出各种 Docker 操作命令。

#### 常用命令：

+ `docker run`：运行容器。
+ `docker ps`：列出正在运行的容器。
+ `docker build`：构建 Docker 镜像。
+ `docker exec`：在容器中执行命令。

### 2、**Docker 守护进程（Docker Daemon）**

Docker 守护进程（通常是 `dockerd`）是 Docker 架构的核心，负责管理容器生命周期、构建镜像、分发镜像等任务。

守护进程通常以后台进程的方式运行，等待来自 Docker 客户端的 API 请求。

**功能**：

+ 启动和停止容器。
+ 构建、拉取和推送镜像。
+ 管理容器的网络和存储。
+ 启动、停止、查看容器日志等。
+ 与 Docker 注册表进行通信，管理镜像的存储与分发。

Docker 守护进程监听来自 Docker 客户端的请求，并且通过 Docker API 执行这些请求。守护进程将负责容器、镜像等 Docker
对象的管理，并根据请求的参数启动容器、删除容器、修改容器配置等。

启动 Docker 守护进程（通常是自动启动的）：

```shell
sudo systemctl start docker
```

### 3、**Docker 引擎 API（Docker Engine API）**

Docker 引擎 API 是 Docker 提供的 RESTful 接口，允许外部客户端与 Docker 守护进程进行通信。通过这个
API，用户可以执行各种操作，如启动容器、构建镜像、查看容器状态等。API 提供了 HTTP 请求的接口，支持跨平台调用。

**功能**：

+ 向 Docker 守护进程发送 HTTP 请求，实现容器、镜像的管理。
+ 提供 RESTful 接口，允许通过编程与 Docker 进行交互。

可以通过 `curl` 或其他 HTTP 客户端访问 Docker 引擎 API。例如，查询当前 Docker 守护进程的版本：

```shell
curl --unix-socket /var/run/docker.sock http://localhost/version
```

### 4、**Docker 容器（Docker Containers）**

容器是 Docker 的执行环境，它是轻量级、独立且可执行的软件包。容器是从 Docker
镜像启动的，包含了运行某个应用程序所需的一切——从操作系统库到应用程序代码。容器在运行时与其他容器和宿主机共享操作系统内核，但容器之间的文件系统和进程是隔离的。

**功能**：

+ 提供独立的运行环境，确保应用程序在不同的环境中具有一致的行为。
+ 容器是临时的，通常在任务完成后被销毁。

容器的生命周期是由 Docker 守护进程管理的。容器可以在任何地方运行，因为它们不依赖于底层操作系统的配置，所有的运行时依赖已经封装在镜像中。

启动一个容器：

```shell
docker run -d ubuntu
```

### 5、**Docker 镜像（Docker Images）**

Docker 镜像是容器的只读模板。每个镜像都包含了应用程序运行所需的操作系统、运行时、库、环境变量和应用代码等。镜像是静态的，用户可以根据镜像启动容器。

**功能**：

+ 镜像是构建容器的基础，每个容器实例化时都会使用镜像。
+ 镜像是只读的，不同容器使用同一个镜像时，容器中的文件系统层是独立的。

Docker 镜像可以通过 `docker pull` 从 Docker Hub 或私有注册表拉取，也可以通过 `docker build` 从 Dockerfile 构建。

拉取 Ubuntu 镜像：

```shell
docker pull ubuntu
```

### 6. **Docker 仓库（Docker Registries）**

Docker 仓库是用来存储 Docker 镜像的地方，最常用的公共仓库是 **Docker Hub**。用户可以从 Docker Hub
下载镜像，也可以上传自己的镜像分享给其他人。除了公共仓库，用户也可以部署自己的私有 Docker 仓库来管理企业内部的镜像。

**功能**：

+ 存储 Docker 镜像。
+ 提供镜像的上传和下载功能。

Docker Hub 提供了大量官方和社区维护的镜像，如 Ubuntu、Nginx、MySQL 等。

推送镜像到 Docker Hub：

```shell
docker push <username>/<image_name>
```

### 7、**Docker Compose**

Docker Compose 是一个用于定义和运行多容器 Docker 应用的工具。通过 Compose，用户可以使用一个 `docker-compose.yml`
配置文件定义多个容器（服务），并可以通过一个命令启动这些容器。Docker Compose 主要用于开发、测试和部署多容器的应用。

**功能**：

+ 定义和运行多个容器组成的应用。
+ 通过 YAML 文件来配置应用的服务、网络和卷等。

创建一个简单的 `docker-compose.yml` 文件来配置一个包含 Web 服务和数据库服务的应用：

```shell
version: '3'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  db:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: example
```

启动 Compose 定义的所有服务：

```shell
docker-compose up
```

### 8、**Docker Swarm**

Docker Swarm 是 Docker 提供的集群管理和调度工具。它允许将多个 Docker 主机（节点）组织成一个集群，并通过 Swarm
集群管理工具来调度和管理容器。Swarm 可以实现容器的负载均衡、高可用性和自动扩展等功能。

**功能**：

+ 管理多节点 Docker 集群。
+ 通过调度器管理容器的部署和扩展。

初始化 Swarm 集群：

```shell
docker swarm init
```

### 9、**Docker 网络（Docker Networks）**

Docker 网络允许容器之间相互通信，并与外部世界进行连接。Docker 提供了多种网络模式来满足不同的需求，如 `bridge`
网络（默认）、`host` 网络和 `overlay` 网络等。

**功能**：

+ 管理容器间的网络通信。
+ 支持不同的网络模式，以适应不同场景下的需求。

创建一个自定义网络并将容器连接到该网络：

```shell
docker network create my_network
docker run -d --network my_network ubuntu
```

### 10. **Docker 卷（Docker Volumes）**

Docker 卷是一种数据持久化机制，允许数据在容器之间共享，并且独立于容器的生命周期。与容器文件系统不同，卷的内容不会随着容器的销毁而丢失，适用于数据库等需要持久存储的应用。

**功能**：

+ 允许容器间共享数据。
+ 保证数据持久化，独立于容器的生命周期。

创建并挂载卷：

```shell
docker volume create my_volume
docker run -d -v my_volume:/data ubuntu
```

