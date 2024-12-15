# docker compose run 命令

[Docker命令大全](./docker-command-manual.md)

docker compose run 命令用于启动一个新容器并运行一个特定的服务，而不启动整个 Compose 文件中定义的所有服务。

docker compose run 命令允许你在单个服务上执行任务，如运行一次性命令或调试。

与 docker compose up 的区别在于，run 命令只会运行指定的服务，不会启动依赖它的其他服务。

### 语法
docker compose run [OPTIONS] SERVICE [COMMAND] [ARGS...]

+ **SERVICE**：Compose 文件中定义的服务名称。
+ **COMMAND** 和 **ARGS**：可选参数，指定要在容器内运行的命令及其参数。

**OPTIONS 选项：**

+ `--rm`：运行后自动删除容器。
+ `-d`：以分离模式运行容器。
+ `-T`：禁用伪TTY。

### 实例
**1、运行一个特定服务的命令**

```shell
docker compose run web python manage.py migrate
```

这个命令将在 web 服务的容器中执行 python manage.py migrate 命令，而不启动其他服务。

**2、自动删除容器**

```shell
docker compose run --rm web bash
```

这个命令会运行 web 服务并启动一个 Bash 终端，任务完成后会删除容器。

docker compose run 非常适合用来在服务中执行一次性任务，而不影响其他服务的运行。

# docker compose rm 命令
docker compose rm 命令用于删除已停止的服务容器。

docker compose rm 命令不会删除运行中的容器，主要用于清理已停止或不再需要的容器，以释放系统资源。

### 语法
docker compose rm [OPTIONS] [SERVICE...]

+ **SERVICE**（可选）：要删除的服务容器的名称。如果不指定服务名称，将删除所有已停止的服务容器。

**OPTIONS 选项：**

+ `-f, --force`：强制删除容器，而不提示用户确认。
+ `-s, --stop`：首先停止正在运行的容器，然后删除它们。
+ `-v, --volumes`：同时删除与容器关联的卷（volume）。

### 实例
**1、删除所有已停止的服务容器**

```shell
docker compose rm
```

会列出并提示是否删除所有停止的服务容器。

**2、强制删除所有已停止的服务容器**

```shell
docker compose rm -f
```

直接删除停止的容器，不会提示用户确认。

**3、删除特定服务的已停止容器**

```shell
docker compose rm web
```

仅删除 web 服务的已停止容器。

**4、删除并清理相关卷**

```shell
docker compose rm -v
```

删除已停止的容器并同时删除与之关联的卷。

# docker compose ps 命令
docker compose ps 命令用于列出与 Docker Compose 项目相关的容器及其状态。

docker compose ps 能显示当前项目中所有服务容器的运行状态、端口映射等信息。

### 语法
docker compose ps [OPTIONS] [SERVICE...]

+ **SERVICE**（可选）：指定要查看状态的服务名称。如果不指定，将列出所有服务的容器状态。

**OPTIONS 选项：**

+ `-a, --all`：列出所有容器，包括已停止的容器。
+ `-q, --quiet`：仅显示容器 ID，不显示其他信息。
+ `--services`：仅列出服务名称，不显示容器的详细信息。
+ `--filter`：根据条件过滤输出结果。例如，可以按照状态过滤容器。

### 输出信息
+ **Name**：容器名称。
+ **Command**：容器中运行的命令。
+ **State**：容器的状态（如 Up、Exited）。
+ **Ports**：容器的端口映射。

### 实例
**1、列出所有运行中的容器**

docker compose ps

显示当前项目中正在运行的容器及其状态。

**2、列出所有容器（包括已停止的容器）**

docker compose ps -a

包括停止的容器在内，列出所有容器的状态。

**3、仅显示容器 ID**

docker compose ps -q

只返回容器的 ID，不包括其他详细信息。

**4、列出所有服务的名称**

docker compose ps --services

只显示服务名称，而不列出容器的详细信息。

**5、根据状态过滤容器**

docker compose ps --filter "status=running"

仅列出状态为"running"的容器。

# docker compose build 命令
docker compose build 命令用于根据 docker-compose.yml 文件中的定义，构建服务的镜像。

docker compose build 会从指定的 Dockerfile 或 build 上下文中构建镜像，并为所有服务准备好容器。

### 语法
docker compose build [OPTIONS] [SERVICE...]

+ **SERVICE**（可选）：指定要构建的服务名称。如果不指定，将为所有服务构建镜像。

**OPTIONS 选项：**

+ `--no-cache`：在构建过程中不使用缓存层，强制从头开始构建镜像。
+ `--pull`：始终尝试从注册表中拉取最新的基础镜像。
+ `--build-arg`：传递构建时的变量（类似于 Docker 的 `--build-arg` 选项）。
+ `--progress`：指定构建的进度样式（`auto`、`plain`、`tty`），影响显示的输出方式。
+ `--parallel`：并行构建多个服务镜像以提高速度。
+ `--no-rm`：构建失败时，保留中间容器（默认在成功或失败后都会删除中间容器）。

### 实例
**1、为所有服务构建镜像**

docker compose build

根据 docker-compose.yml 中的配置，为所有服务构建镜像。

**2、构建特定服务的镜像**

docker compose build web

仅为 web 服务构建镜像。

**3、不使用缓存构建镜像**

docker compose build --no-cache

强制 Docker 从头构建所有镜像，不使用之前构建的缓存层。

**4、从最新基础镜像构建**

docker compose build --pull

确保 Docker 拉取最新的基础镜像，而不是使用本地镜像。

**5、传递构建变量**

docker compose build --build-arg NODE_ENV=production

通过 --build-arg 传递构建时所需的变量，例如传递 NODE_ENV 环境变量。

# docker compose up 命令
docker compose up 命令用于启动 Docker Compose 项目中定义的所有服务容器，并确保它们按照 docker-compose.yml 文件中的配置运行。

docker compose up 命令不仅会启动服务，还会自动构建尚未构建的镜像（如有必要），创建网络和卷，并以容器的形式启动服务。

### 语法
docker compose up [OPTIONS] [SERVICE...]

+ **SERVICE**（可选）：可以指定一个或多个服务，仅启动这些服务。如果不指定，将启动所有服务。

**OPTIONS 选项：**

+ `-d, --detach`：以后台模式运行容器，类似于在 `docker run` 中使用 `-d` 选项。
+ `--build`：在启动之前强制重新构建镜像，即使镜像已存在。
+ `--no-build`：阻止在启动时构建镜像，即使镜像不存在也不构建。
+ `--force-recreate`：强制重新创建容器，即使它们已经存在且内容未发生变化。
+ `--no-recreate`：如果容器已经存在，则不重新创建它们（默认行为是如果配置文件变化则重新创建）。
+ `--remove-orphans`：移除不再在 Compose 文件中定义的孤立容器。
+ `-V, --renew-anon-volumes`：重新创建匿名卷（删除旧的卷并创建新的）。

### 实例
**1、启动所有服务并附加到控制台**

docker compose up

启动 Compose 文件中定义的所有服务，并将日志输出显示在当前终端中。

**2、在后台模式运行服务**

docker compose up -d

以后台（分离）模式运行所有服务，终端不会输出服务的日志。

**3、仅启动指定服务**

docker compose up web

只启动 web 服务，而不启动其他服务。

**4、启动服务并强制重建镜像**

docker compose up --build

在启动服务之前，强制重新构建服务镜像。

**5、启动服务并强制重新创建容器**

docker compose up --force-recreate

强制重新创建服务容器，即使之前的容器存在且未发生更改。

**6、启动服务并移除不再存在于 Compose 文件中的孤立容器**

docker compose up --remove-orphans

移除任何不再在当前 docker-compose.yml 文件中定义的容器。

# docker compose ls 命令
docker compose ls 命令用于列出当前系统中所有 Docker Compose 项目及其状态。

docker compose ls 命令可以帮助你快速查看有哪些 Compose 项目正在运行或处于其他状态。

### 语法
docker compose ls [OPTIONS]

**OPTIONS 选项：**

+ `--all`：显示所有项目，包括未启动的项目。
+ `--filter`：根据条件过滤输出结果。例如，可以按状态过滤。
+ `--format`：指定输出格式（如 `table`、`json` 等）。
+ `--quiet`：只显示项目名称，而不显示其他信息。

**输出信息：**

`docker compose ls` 的输出信息包括以下字段：

+ **Name**：项目名称。
+ **Status**：项目的状态（例如 `running`、`exited` 等）。
+ **Config Files**：与项目相关联的 `docker-compose.yml` 文件的路径。

### 实例
**1、列出所有运行的 Docker Compose 项目**

docker compose ls

显示当前正在运行的所有项目及其状态。

**2、列出所有项目（包括未启动的）**

docker compose ls --all

显示包括未启动的项目在内的所有 Compose 项目。

**3、仅显示项目名称**

docker compose ls --quiet

只返回项目名称，而不包括详细信息。

**4、按状态过滤项目**

docker compose ls --filter "status=running"

仅显示状态为 running 的项目。

# docker compose start 命令
docker compose start 命令用于启动已存在但目前处于停止状态的 Docker Compose 服务容器。

与 docker compose up 不同，它不会创建新的容器或重新构建镜像，只会启动已经创建但停止的容器。

### 语法
docker compose start [SERVICE...]

+ **SERVICE**（可选）：指定要启动的服务名称。如果不指定，将启动所有已停止的服务容器。

### 实例
**1、启动所有已停止的服务**

docker compose start

这将启动所有当前处于停止状态的容器。

**2、启动特定服务**

docker compose start web

仅启动 web 服务的容器，而不影响其他服务。

# docker compose restart 命令
docker compose restart 命令命令用于重启一个或多个服务。

与 docker compose restart 命令会停止正在运行的服务容器，然后重新启动它们。

如果你需要更新配置或者只是想简单地重启服务而不需要重建容器，那么 restart 是很有用的。

### 语法
docker compose restart [SERVICE...]

+ **SERVICE**（可选）：可以指定要重启的一个或多个服务名称。如果不指定服务名称，则会重启所有在 docker-compose.yml 文件中定义的服务。

### 实例
**1、重启所有服务：**

docker compose restart

**2、重启特定的服务（例如名为 web 和 db 的服务）：**

docker compose restart web db

确保你在包含 docker-compose.yml 文件的目录中执行这些命令，或者通过 -f 参数指定 docker-compose.yml 文件的位置。例如，如果你的 docker-compose.yml 文件不在当前目录下，你可以这样指定文件位置：

docker compose -f /path/to/docker-compose.yml restart

这样做可以让你控制哪个 docker-compose.yml 文件被用来管理服务。

