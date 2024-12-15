# Docker login/logout 命令

[Docker命令大全](./docker-command-manual.md)

`docker login` 和 `docker logout` 命令用于管理 Docker 客户端与 Docker 注册表的身份验证。通过 `docker login` 命令，用户可以登录到 Docker 注册表，访问和推送镜像；通过 `docker logout` 命令，用户可以退出登录。

+ **docker login :** 登陆到 一个Docker 镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub
+ **docker logout :** 登出一个D ocker 镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub

---

## docker login
`docker login` 命令用于登录到 Docker 注册表。

默认情况下，它登录到 Docker Hub，但也可以登录到其他 Docker 注册表。

### 语法
docker login [OPTIONS] [SERVER]

+ `SERVER`: Docker 注册表的服务器地址（默认是 Docker Hub）。
+ `-u, --username`: 登录用户名。
+ `-p, --password`: 登录密码（不推荐在命令行使用）。
+ `--password-stdin`: 从标准输入读取密码。

### 使用示例
**1、登录到 Docker Hub**

```shell
docker login
```

提示输入 Docker Hub 用户名和密码。

**2、登录到 Docker Hub（指定用户名）**

```shell
docker login --username myusername
```

**3、提示输入 Docker Hub 密码。**

从标准输入读取密码：

```shell
echo "mypassword" | docker login --username myusername --password-stdin
```

从标准输入读取密码，避免在命令行明文输入密码。

**4、登录到自定义注册表**

```shell
docker login myregistry.com
```

提示输入自定义注册表的用户名和密码。

---

## docker logout
`docker logout` 命令用于退出当前登录的 Docker 注册表。默认情况下，它退出 Docker Hub，但也可以指定其他注册表。

### 语法
docker logout [SERVER]

+ `SERVER`: Docker 注册表的服务器地址（默认是 Docker Hub）。

### 使用示例
**1、退出 Docker Hub**

```shell
docker logout
```

退出当前用户在 Docker Hub 的登录状态。

**2、退出自定义注册表**

```shell
docker logout myregistry.com
```

退出当前用户在 myregistry.com 的登录状态。

---

## 操作实例
**1、登录 Docker Hub**

```shell
docker login
```

输出：

```shell
Username: myusername
Password: 
Login Succeeded
```

**2、从标准输入读取密码登录 Docker Hub**

```shell
echo "mypassword" | docker login --username myusername --password-stdin
```

输出：

```shell
Login Succeeded
```

**3、登录自定义注册表**

```shell
docker login myregistry.com
```

输出：

```shell
Username: myusername
Password: 
Login Succeeded
```

**4、退出 Docker Hub**

```shell
docker logout
```

输出：

```shell
Removing login credentials for https://index.docker.io/v1/
```

**5、退出自定义注册表**

```shell
docker logout myregistry.com
```

输出：

```shell
Removing login credentials for myregistry.com
```

### 注意事项
+ 不推荐在命令行直接使用 `-p` 选项输入密码，因为这样密码会以明文形式暴露在命令历史记录中。
+ 使用 `--password-stdin` 可以避免密码明文暴露，增强安全性。
+ 确保在公共或共享环境中执行 `docker logout`，以防止其他用户访问您的账户。