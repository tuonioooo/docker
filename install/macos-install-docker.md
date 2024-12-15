# MacOS Docker 安装

## 使用 Homebrew 安装
macOS 我们可以使用 Homebrew 来安装 Docker。

Homebrew 的 Cask 已经支持 Docker for Mac，因此可以很方便的使用 Homebrew Cask 来进行安装：

```shell
$ brew install --cask --appdir=/Applications docker

==> Creating Caskroom at /usr/local/Caskroom
==> We'll set permissions properly so we won't need sudo in the future
Password:          # 输入 macOS 密码
==> Satisfying dependencies
==> Downloading https://download.docker.com/mac/stable/21090/Docker.dmg
######################################################################## 100.0%
==> Verifying checksum for Cask docker
==> Installing Cask docker
==> Moving App 'Docker.app' to '/Applications/Docker.app'.
&#x1f37a;  docker was successfully installed!
```

在载入 Docker app 后，点击 Next，可能会询问你的 macOS 登陆密码，你输入即可。之后会弹出一个 Docker 运行的提示窗口，状态栏上也有有个小鲸鱼的图标（![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734148220935-8b4bf771-e188-4c80-8dd4-ae3594f4f426.png)）。

---

## 手动下载安装
如果需要手动下载，请点击以下链接下载 [Install Docker Desktop on Mac](https://docs.docker.com/docker-for-mac/install/) 。

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734148221046-9130d6fe-6742-4a4f-b736-60977bcd4bbc.png)

如同 macOS 其它软件一样，安装也非常简单，双击下载的 .dmg 文件，然后将鲸鱼图标拖拽到 Application 文件夹即可。

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734148221147-191d28e0-bb41-417e-b71f-5e7638b40a69.png)

从应用中找到 Docker 图标并点击运行。可能会询问 macOS 的登陆密码，输入即可。

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734148221159-cbe2f3a7-5227-4b9b-ae4a-f28eafbcb7a3.png)

点击顶部状态栏中的鲸鱼图标会弹出操作菜单。

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734148220942-928295af-def7-4caa-995e-c378a2b0533e.png)

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734148222188-37d69f7f-9d66-4a5d-8492-abad22ecabd2.png)

第一次点击图标，可能会看到这个安装成功的界面，点击 "Got it!" 可以关闭这个窗口。

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734148222405-3a7a271c-8737-453e-8f06-b166dc6ccce0.png)

启动终端后，通过命令可以检查安装后的 Docker 版本。

```shell
$ docker --version
Docker version 17.09.1-ce, build 19e2cf6
```

## 镜像加速
鉴于国内网络问题，后续拉取 Docker 镜像十分缓慢，我们可以需要配置加速器来解决，我使用的是网易的镜像地址：**http://hub-mirror.c.163.com**。

在任务栏点击 Docker for mac 应用图标 -> Perferences... -> Daemon -> Registry mirrors。在列表中填写加速器地址即可。修改完成之后，点击 Apply & Restart 按钮，Docker 就会重启并应用配置的镜像地址了。

![](https://cdn.nlark.com/yuque/0/2024/png/2472623/1734148222358-3d8f1e2f-54e3-4e21-979f-3d6206c11fca.png)

之后我们可以通过 docker info 来查看是否配置成功。

```shell
$ docker info
...
Registry Mirrors:
 http://hub-mirror.c.163.com
Live Restore Enabled: false
```

