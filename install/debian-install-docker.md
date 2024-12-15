# Debian Docker 安装

## 安装须知

### 操作系统要求
Docker 支持以下的 64 位 Debian 版本：

+ Debian Bookworm 12 （稳定版）
+ Debian Bullseye 11 （旧稳定版）

Docker Engine for Debian支持架构包括：x86_64（或amd64）、armhf、arm64和ppc64le（ppc64el）。

### 卸载旧版本
如果你之前安装过 Docker Engine 之前，你需要卸载旧版本，避免冲突：

```shell
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

---

## 使用官方安装脚本自动安装
安装命令如下：

```shell
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

---

## 手动安装
### 1. 更新软件包
首先，更新现有的软件包和包缓存：

```shell
sudo apt update
sudo apt upgrade
```

### 2. 安装依赖包
安装一些需要的依赖包，这些包允许 apt 使用 HTTPS 协议来访问 Docker 仓库：

```shell
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

### 3. 添加 Docker 官方 GPG 密钥
使用下面的命令来添加 Docker 官方的 GPG 密钥：

```shell
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

### 4. 添加 Docker 仓库
添加 Docker 官方的 APT 软件源：

```shell
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# 更新
sudo apt-get update
```

### 5. 更新 APT 软件包缓存
添加仓库后，更新 APT 包索引：

```shell
sudo apt update
```

确保你现在从 Docker 官方仓库安装 Docker 而不是 Debian 默认仓库：

```shell
apt-cache policy docker-ce
```

你应该看到它指向 https://download.docker.com/，确保这就是官方的 Docker 仓库。

### 6. 安装 Docker
现在，你可以安装 Docker：

```shell
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 7. 启动并验证 Docker
启动 Docker 并设置为开机自启：

```shell
sudo systemctl start docker
sudo systemctl enable docker
```

你可以使用以下命令来验证 Docker 是否安装成功：

```shell
sudo docker --version
```

运行以下测试命令确保 Docker 正常工作：

```shell
sudo docker run hello-world
```

### 卸载 docker
删除安装包：

```shell
sudo apt-get purge docker-ce
```

删除镜像、容器、配置文件等内容：

```shell
sudo rm -rf /var/lib/docker
```

