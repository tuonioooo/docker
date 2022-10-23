# docker可视化工具



## portainer

docker图形化界面管理工具，提供一个后台面板供我们操作

部署步骤：

1、查询当前Portainer镜像，选择start值比较高的

命令：

docker search portainer

2、下载指定portainer镜像

命令：

docker pull portainer/portainer

3、本次只部署单机版，命令如下

docker run -d -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --name prtainer-test portainer/portainer

如下图：

![img](https://img2018.cnblogs.com/blog/954348/201912/954348-20191211153203115-79465651.png)

![img](https://img2018.cnblogs.com/blog/954348/201912/954348-20191211152823762-1999879810.png)

参数说明：
-d：容器在后台运行；
-p 9000:9000 ：宿主机9000端口映射容器中的9000端口
–restart 标志会检查容器的退出代码，并据此来决定是否要重启容器，默认是不会重启。

–restart=always：自动重启该容器
-v /var/run/docker.sock:/var/run/docker.sock ：把宿主机的Docker守护进程(Docker daemon)默认监听的Unix域套接字挂载到容器中
-v portainer_data:/data ：把宿主机portainer_data数据卷挂载到容器/data目录
–name prtainer-test ： 给容器起名为portainer-test



部署步骤：

1、查询当前Portainer镜像，选择start值比较高的

命令：

docker search portainer

2、下载指定portainer镜像

命令：

docker pull portainer/portainer

3、本次只部署单机版，命令如下

docker run -d -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --name prtainer-test portainer/portainer

如下图：

![img](https://img2018.cnblogs.com/blog/954348/201912/954348-20191211153203115-79465651.png)

![img](https://img2018.cnblogs.com/blog/954348/201912/954348-20191211152823762-1999879810.png)

参数说明：
-d：容器在后台运行；
-p 9000:9000 ：宿主机9000端口映射容器中的9000端口
–restart 标志会检查容器的退出代码，并据此来决定是否要重启容器，默认是不会重启。

–restart=always：自动重启该容器
-v /var/run/docker.sock:/var/run/docker.sock ：把宿主机的Docker守护进程(Docker daemon)默认监听的Unix域套接字挂载到容器中
-v portainer_data:/data ：把宿主机portainer_data数据卷挂载到容器/data目录
–name prtainer-test ： 给容器起名为portainer-test

4、使用docker ps查看进程，如下所示：

![img](https://img2018.cnblogs.com/blog/954348/201912/954348-20191211153234806-1638544994.png)

 

 如果需要汉化，可以下载[汉化包](https://pan.baidu.com/s/1BLXMSmJFcgESeNMhQL26Mg&shfl=sharepset)（提取码：6vjr），之后解压，并将解压后的public文件夹上传到centos系统的根目录下，如下图所示：

![img](https://img2018.cnblogs.com/blog/954348/201912/954348-20191211154002659-629104571.png)

然后执行以下命令：

docker run -d -p 9000:9000 --restart=always  -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -v /public:/public --name prtainer-test  portainer/portainer（如果已部署，需要将之前的容器删除）

5、Portainer的web页面登录

在浏览器输入部署服务器的IP:9000，回车，显示如下界面：

![img](https://img2018.cnblogs.com/blog/954348/201912/954348-20191211154735320-1919071871.png)

 由于是本地docker，所有选择local

![img](https://img2018.cnblogs.com/blog/954348/201912/954348-20191211155241808-1937877821.png)

 之后点击“Connect”，成功后跳转到主页界面（汉化后），如下图：

![img](https://img2020.cnblogs.com/blog/2355966/202111/2355966-20211118113232340-1101562485.png)

 点击“local”，进入该docker内，展示相关容器、堆栈、镜像等信息，如下图所示：

![img](https://img2020.cnblogs.com/blog/2355966/202111/2355966-20211118113043413-1112303508.png)

 

