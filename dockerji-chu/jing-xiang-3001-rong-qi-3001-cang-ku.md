# 镜像、容器、仓库

## Docker生命周期

Docker 包括三个基本概念:

镜像（Image）  
容器（Container）  
仓库（Repository）

这三部分组成了Docker的整个生命周期，如下图所示，容器是由镜像实例化而来的，这和我们学习的面向对象的概念十分相似，我们可以把`镜像`想象成`类`,把`容器`想象成类经过实例化后的`对象`，这样就非常好理解镜像和容器的关系了。

![](/assets/2156466-b4341e9da2e6e170.jpg)

Docker生命周期

## Docker镜像

Docker的镜像概念类似于虚拟机里的镜像，是一个只读的模板，一个独立的文件系统，包括运行容器所需的数据，可以用来创建新的容器。  
例如：一个镜像可以包含一个完整的 ubuntu 操作系统环境，里面仅安装了Mysql或用户需要的其它应用程序。

Docker的镜像实际上由一层一层的文件系统组成，这种层级的文件系统被称为`UnionFS`。镜像可以基于`Dockerfile`构建，Dockerfile是一个描述文件，里面包含若干条命令，每条命令都会对基础文件系统创建新的层次结构。

Docker 提供了一个很简单的机制来创建镜像或者更新现有的镜像，用户甚至可以直接从其他人那里下载一个已经做好的镜像来直接使用。

> 注：镜像是只读的，可以理解为静态文件。

## Docker容器

Docker 利用容器来运行应用。

Docker容器是由Docker镜像创建的运行实例。Docker容器类似虚拟机，可以支持的操作包括启动，停止，删除等。每个容器间是相互隔离的，容器中会运行特定的应用，包含特定应用的代码及所需的依赖文件。

可以把容器看做是一个简易版的 Linux 环境（包括root用户权限、进程空间、用户空间和网络空间等）和运行在其中的应用程序。

> 注：相对于镜像来说容器是动态的，容器在启动的时候创建一层可写层作为最上层。

## Docker仓库

如果你使用过git和github就很容易理解Docker的仓库概念。Docker 仓库的概念跟Git 类似，注册服务器可以理解为 GitHub 这样的托管服务。

Docker 仓库是用来包含镜像的位置，Docker提供一个注册服务器（Register）来保存多个仓库，每个仓库又可以包含多个具备不同tag的镜像。Docker运行中使用的默认仓库是 Docker Hub 公共仓库。

仓库支持的操作类似git，当用户创建了自己的镜像之后就可以使用 push 命令将它上传到公有或者私有仓库，这样下次在另外一台机器上使用这个镜像时候，只需要从仓库上 pull 下来就可以了。.

示意图如下：![](/assets/docker安装命令.png)

## Reference

> [http://tech.365rili.com/?p=41](https://link.jianshu.com/?t=http://tech.365rili.com/?p=41) [https://yeasy.gitbooks.io/docker\_practice/content/index.html](https://link.jianshu.com/?t=https://yeasy.gitbooks.io/docker_practice/content/index.html)  
> [http://dockone.io/article/783](http://dockone.io/article/783)  
> [https://www.cnblogs.com/bethal/p/5942369.html](https://www.cnblogs.com/bethal/p/5942369.html)  
> [https://blog.csdn.net/xfyimengweima1314/article/details/79046873](https://blog.csdn.net/xfyimengweima1314/article/details/79046873)

思想必定是在与人交流中产生，而在孤独中进行加工和表达

