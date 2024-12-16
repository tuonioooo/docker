# Docker 安装 Portainer

## portainer
docker图形化界面管理工具，提供一个后台面板供我们操作

部署步骤：

#### 1、查询当前Portainer镜像，选择start值比较高的

命令：

```shell
docker search portainer
```

#### 2、下载指定portainer镜像

命令：

```shell
docker pull portainer/portainer
```

#### 3、本次只部署单机版，命令如下

```shell
docker run -d -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --name prtainer-test portainer/portainer
```

如下图：

![](https://camo.githubusercontent.com/e1cb8697d08c1ebcf74868a52307dd1e19d6315bd5b25867403cc0d9203c9c91/68747470733a2f2f696d67323031382e636e626c6f67732e636f6d2f626c6f672f3935343334382f3230313931322f3935343334382d32303139313231313135333230333131352d37393436353635312e706e67)

![](https://camo.githubusercontent.com/494f74e8f82e1a832411e9812ffe0d98b70f545a648b8d749bb6fa27f11bb608/68747470733a2f2f696d67323031382e636e626c6f67732e636f6d2f626c6f672f3935343334382f3230313931322f3935343334382d32303139313231313135323832333736322d313939393837393831302e706e67)

> [!NOTE]
>
> **参数说明：**
>
> -d：容器在后台运行；
>
>  -p 9000:9000 ：宿主机9000端口映射容器中的9000端口 –restart 标志会检查容器的退出代码，并据此来决定是否要重启容器，默认是不会重启。
>
> –restart=always：自动重启该容器 
>
> -v /var/run/docker.sock:/var/run/docker.sock ：把宿主机的Docker守护进程(Docker daemon)默认监听的Unix域套接字挂载到容器中 
>
> -v portainer_data:/data ：把宿主机portainer_data数据卷挂载到容器/data目录 
>
> –name prtainer-test ： 给容器起名为portainer-test

#### 4、使用docker ps查看进程，如下所示：

![](https://camo.githubusercontent.com/50330e9f61eb758b37be09d1b74fe907cb82d6a9a2df7032aa824f0f88dd0ad2/68747470733a2f2f696d67323031382e636e626c6f67732e636f6d2f626c6f672f3935343334382f3230313931322f3935343334382d32303139313231313135333233343830362d313633383534343939342e706e67)

如果需要汉化，可以下载[汉化包](https://pan.baidu.com/s/1BLXMSmJFcgESeNMhQL26Mg&shfl=sharepset)（提取码：6vjr），之后解压，并将解压后的public文件夹上传到centos系统的根目录下，如下图所示：

![](https://camo.githubusercontent.com/0c4646557a6fde38bf2566959826fab3f6c6ac345661177f317311843311a5dc/68747470733a2f2f696d67323031382e636e626c6f67732e636f6d2f626c6f672f3935343334382f3230313931322f3935343334382d32303139313231313135343030323635392d3632393130343537312e706e67)

然后执行以下命令：

```shell
docker run -d -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -v /public:/public --name prtainer-test portainer/portainer（如果已部署，需要将之前的容器删除）
```

#### 5、Portainer的web页面登录

在浏览器输入部署服务器的IP:9000，回车，显示如下界面：

![](https://camo.githubusercontent.com/29c910392eef567ceea42dbd95436bd33a333c77fd213f4d7ce4867e0b02f3e9/68747470733a2f2f696d67323031382e636e626c6f67732e636f6d2f626c6f672f3935343334382f3230313931322f3935343334382d32303139313231313135343733353332302d313931393037313837312e706e67)

由于是本地docker，所有选择local

![](https://camo.githubusercontent.com/e1c3a2a083c5ae3a2dfddafc5994d418e05a215ecfbf113774ddd4598d8c23dd/68747470733a2f2f696d67323031382e636e626c6f67732e636f6d2f626c6f672f3935343334382f3230313931322f3935343334382d32303139313231313135353234313830382d313933373837373832312e706e67)

之后点击“Connect”，成功后跳转到主页界面（汉化后），如下图：

![](https://camo.githubusercontent.com/fbf86cfc693f9405c9ad39ab657333ac478c488e3f8b1ddda24c0a8f56abc880/68747470733a2f2f696d67323032302e636e626c6f67732e636f6d2f626c6f672f323335353936362f3230323131312f323335353936362d32303231313131383131333233323334302d313130313536323438352e706e67)

点击“local”，进入该docker内，展示相关容器、堆栈、镜像等信息，如下图所示：

![](https://camo.githubusercontent.com/cc78ef24d5f1a00bb3efdcdd36a33f77486192877c8414b7406938ce18ee2c9b/68747470733a2f2f696d67323032302e636e626c6f67732e636f6d2f626c6f672f323335353936362f3230323131312f323335353936362d32303231313131383131333034333431332d313131323330333530382e706e67)

