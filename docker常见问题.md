# docker常见问题



## docker启动容器之后马上又自动关闭解决办法

### 问题描述



centos 启动一个容器添加了-d 参数，但是[docker](https://so.csdn.net/so/search?q=docker&spm=1001.2101.3001.7020) ps 或者docker ps -a查看却已经退出了

```
shell>docker run -d centos
a44b2b88559b68a2221c9574490a0e708bff49d88ca21f9e59d3eb245c7c0547
shell>docker ps
```

### 退出原因

1、docker容器运行必须有一个前台进程， 如果没有前台进程执行，容器认为空闲，就会自行退出
2、容器运行的命令如果不是那些一直[挂起](https://so.csdn.net/so/search?q=%E6%8C%82%E8%B5%B7&spm=1001.2101.3001.7020)的命令（ 运行top，tail、循环等），就是会自动退出
3、这个是 docker 的机制问题



方案1：起一个死循环进程，让他不停的循环下去，前台永远有进程执行，那么容器就不会退出了,以centos为例

```
shell>docker run -d centos /bin/sh -c "while true; do echo hello world; sleep 1; done"
```

缺点： 命令太冗长了，还占用一个终端

方案2(推荐)：添加-it 参数交互运行、加-d 参数后台运行

```
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

```
[root@bogon ~]# docker exec -it 05608860479e /bin/sh
/code #
```

### 分析

制作镜像时使用了精简版，只装了sh命令，未安装bash。
如下都是精简版：

```
FROM redis:alpine 
FROM python:3.6-alpine
```

> 参考：https://blog.csdn.net/qq_35764295/article/details/126379879 （更多的sh和bash区别之间的扩展）