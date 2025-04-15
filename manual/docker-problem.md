# Docker 常见问题

## docker启动容器之后马上又自动关闭解决办法

### 问题描述



centos 启动一个容器添加了-d 参数，但是[docker](https://so.csdn.net/so/search?q=docker&spm=1001.2101.3001.7020) ps 或者docker ps -a查看却已经退出了

```shell
shell>docker run -d centos
a44b2b88559b68a2221c9574490a0e708bff49d88ca21f9e59d3eb245c7c0547
shell>docker ps
```

### 退出原因

1、docker容器运行必须有一个前台进程， 如果没有前台进程执行，容器认为空闲，就会自行退出
2、容器运行的命令如果不是那些一直[挂起](https://so.csdn.net/so/search?q=%E6%8C%82%E8%B5%B7&spm=1001.2101.3001.7020)的命令（ 运行top，tail、循环等），就是会自动退出
3、这个是 docker 的机制问题



方案1：起一个死循环进程，让他不停的循环下去，前台永远有进程执行，那么容器就不会退出了,以centos为例

```shell
shell>docker run -d centos /bin/sh -c "while true; do echo hello world; sleep 1; done"
```

缺点： 命令太冗长了，还占用一个终端

方案2(推荐)：添加-it 参数交互运行、加-d 参数后台运行

```shell
shell>docker run -dit centos /bin/bash
```


原文链接：https://blog.csdn.net/m0_67393342/article/details/124171304



## OCI runtime exec failed: exec failed: unable to start container process: exec: "/bin/bash": stat /bin/bash: no such file

### 问题描述

执行进入容器命令时，报如下错误

```
[root@bogon ~]# docker exec -it 05608860479e /bin/bash
OCI runtime exec failed: exec failed: unable to start container process: exec: "/bin/bash": stat /bin/bash: no such file                                or directory: unknown
```

### 解决方案

将` /bin/bash` 换成 `/bin/sh`成功 ，执行成功

```shell
[root@bogon ~]# docker exec -it 05608860479e /bin/sh
/code #
```

### 分析

制作镜像时使用了精简版，只装了sh命令，未安装bash。
如下都是精简版：

```dockerfile
FROM redis:alpine 
FROM python:3.6-alpine
```

> 参考：https://blog.csdn.net/qq_35764295/article/details/126379879 （更多的sh和bash区别之间的扩展）


## ERROR: failed to solve: node:xx-alpine解决办法

🧩 问题原因
ERROR: failed to solve: node:20-alpine: failed to resolve source metadata for docker.io/library/node:20-alpine: docker.io/library/node:20-alpine: not found

✅ 解决方式

改成手动拉取的方式

```bash
docker pull node:20-alpine
```

## ERROR: failed to copy: httpReadSeeker: failed open: unexpected status code

🧩 问题原因
这个错误提示通常在尝试从网络下载或读取文件时遇到，表示服务器返回了一个非预期的状态代码，这意味着请求没有成功完成。

✅ 解决方式，更换镜像源地址

改成手动拉取的方式

## Windows 桌面Docker 执行 `sudo systemctl enable docker` 报错 `Failed to enable unit: Interactive authentication required.`

🧩 原因分析
`systemctl` 是 Linux 系统中用于管理服务的命令，依赖于 systemd 初始化系统。而在 Windows 上，Docker Desktop 并不使用 systemd 来管理 Docker 服务，因此不会存在 `docker.service` 单元。

此外，即使在 Windows 上的 WSL（Windows Subsystem for Linux）环境中，由于 WSL 默认不支持 systemd，运行 `systemctl` 相关命令也会出现类似错误。


✅ 选项一： 在 **Windows 11** 上，将必要的命令添加到[boot]，以下部分/etc/wsl.conf：

```conf
[boot]
command="service docker start"
```

> [!CAUTION] 注意：
> 在最新的预览版中，似乎存在一个问题，当通过实际命令行启动的服务均未运行时，通过此方法启动的任何boot.command服务都会终止。  
> 换句话说，如果您需要解决方式：手动修改`C:\Users\Administrator\.docker\daemon.json`改为正确的json语法，重启Docker Desktop 应用程序即可  
> 在退出 WSL2 会话后继续运行 Docker（或任何其他服务），则可能需要使用选项 2（或卸载预览版）。  

✅ 选项二（推荐）

在 Windows 10 上，在用户启动脚本中运行必要的命令（例如.profile）。首先检查服务是否正在运行，例如：

```shell
wsl.exe -u root -e sh -c "service docker status || service docker start"
```

> [!CAUTION] 注意：
> 这比（下面的选项三）更好，因为它不需要修改。这利用了可以从 WSL 内部运行命令sudoers的优势，使用无需密码即可以 root 身份运行命令的选项。  
> wsl.exe-u root  
> 如果此命令由于某种原因失败，您的默认 WSL 发行版可能与预期不同。请检查 的输出wsl.exe -l -v。  
> 您可以使用 更改默认发行版，wsl.exe --setdefault <distro_name>或者使用 调整上面的命令行以指定发行版-d <distro_name>。

✅ 选项三（旧答案，供后人参考）

visudo或添加规则以/etc/sudoers.d允许您的用户无需密码即可运行命令：

```shell
username ALL = (root) NOPASSWD: /usr/sbin/service docker *
```
然后编辑您的.profile以添加：

```shell
sudo service docker status || sudo service docker start
```

✅ 选项四（推荐）

在 Windows 上使用 Docker Desktop 时，您可以通过以下方式管理 Docker：

- **使用 Docker Desktop 应用程序**：通过图形界面启动和停止 Docker 服务。

- **命令行工具**：使用 `docker` 命令行工具执行相关操作，例如：

  ```powershell
  docker info
  docker run hello-world
  ```



参考来源：[https://stackoverflow.com/questions/65813979/sudo-systemctl-enable-docker-not-available-automatically-run-docker-at-boot-o?utm_source=chatgpt.com](https://stackoverflow.com/questions/65813979/sudo-systemctl-enable-docker-not-available-automatically-run-docker-at-boot-o?utm_source=chatgpt.com)


如果您在 WSL 环境中使用 Docker，可以通过以下方式确保 Docker 正常运行：

1. **确保 Docker Desktop 已启动**：在 Windows 中启动 Docker Desktop 应用程序。
2. **配置 WSL 与 Docker 的集成**：在 Docker Desktop 的设置中，启用与 WSL 的集成。
3. **在 WSL 中使用 Docker 命令**：在 WSL 的终端中，直接使用 `docker` 命令，无需使用 `systemctl`。


💡 总结

在 Windows 上使用 Docker Desktop 时，不需要也无法使用 `systemctl` 来管理 Docker 服务。建议通过 Docker Desktop 提供的图形界面或命令行工具来管理和使用 Docker。