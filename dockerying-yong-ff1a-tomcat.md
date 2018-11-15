# docker应用：tomcat

1

从docker hub中将tomcat镜像拉下来

```
docker pull tomcat
```

2

可以看一下详细信息，使用docker pull tomcat拉取tomcat时若不指定标签，则会使用默认的latest标签

```
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
docker.io/tomcat        latest              6759d91a032b        4 days ago          463 MB
docker.io/hello-world   latest              4ab4c602aa5e        2 months ago        1.84 kB
```

3

```
docker run -d -p 16000:8000 tomcat
```

接下来我们要让这个镜像作为容器在后台运行起来，并且将该容器的端口号暴露出来，也就是说，将容器的端口映射到我们自己计算机的物理端口上

-d参数是让tomcat容器在后台运行

-p参数是将容器的端口映射给宿主机的端口

我们可以用docker run --help来看该命令各个参数的意义

注意：这里的16000是宿主机的端口，8080是容器的端口，不可以写反

4

成功执行后，我们就可以通过访问16000端口来看tomcat是否成功运行

![](/assets/WNOPWO~FMWA{%28RW$7GSY%297X.png)

可以看到，我这里已经成功运行了 或者在命令行中使用curl命令来看是否成功

```
curl 127.0.0.1:16000
```

### 参考

[https://blog.csdn.net/hty46565/article/details/76590067](https://blog.csdn.net/hty46565/article/details/76590067)

