# docker、docker engine和docker desktop区别

## 前言
安装docker时，官网有docker desktop和docker engine两种，这两种有什么不同？应该安装哪种呢？

![在这里插入图片描述](https://img-blog.csdnimg.cn/c665409425db475ea6c4c8bbadcd2a52.png)

## docker engine vs docker desktop
* docker desktop包含虚拟机、图形界面及其他特性比如带了一个单节点的kubernetes集群，虚拟机里有一个Docker CE (Docker Community Edition)守护进程。
* docker engine，根据官方文档包含三部分
  * 守护进程dockerd 
  * api，程序可通过api与dockerd交互
  * 命令行工具客户端docker，命令docker command中的docker

在docker desktop里，docker客户端是在宿主机中，守护进程在虚拟机里。当要访问docker desktop的ip时，要谨记一条-docker network存在于虚拟机中，即使使用docker run --net host那也是使用虚拟机的host network，而不是物理机的network。docker container运行在虚拟机中，其他一切都是结果。
在Windows和MacOS中，要想运行linux容器，必须有虚拟机，在linux中是不需要的;不过，为了一致体验，如果在linux中安装desktop也会安装一个虚拟机。

官方文档是如此描述的[Docker Engine](https://docs.docker.com/engine/)

> Docker Engine is an open source containerization technology for building and containerizing your applications. Docker Engine acts as a client-server application with:
> A server with a long-running daemon process dockerd.
> APIs which specify interfaces that programs can use to talk to and instruct the Docker daemon.
> A command line interface (CLI) client docker.

[docker论坛](https://forums.docker.com/t/difference-between-docker-desktop-and-docker-engine/124612)对docker desktop的描述。

> Basically Docker Desktop is a virtual machine + Graphical user interface with some extra features like the new extensions and running a single-node Kubernetes “cluster” easily. Inside the virtual machine there is Docker CE (Docker Community Edition) daemon.
>

[官方文档](https://docs.docker.com/desktop/)中提到的docker desktop组成部分。

![在这里插入图片描述](https://img-blog.csdnimg.cn/84ce5b63b969411c835461a1562e6669.png)

## 结论

如果装在macOS、windows、linux等有图形的桌面电脑，则用docker desktop。比如windows电脑、macos电脑、ubuntu、fedora电脑。
如果装在没有图形的电脑，则用docker engine，比如公司的centos服务器、阿里云的centos服务器等

原文链接：https://blog.csdn.net/wangjun5159/article/details/127276708