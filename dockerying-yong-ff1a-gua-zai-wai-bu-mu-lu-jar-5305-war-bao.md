# docker应用：挂载外部目录jar包/war包

* ### docker执行容器外部的Jar文件

1.下载java镜像

```
docker pull java:8u111
```

2.执行docker命令启动jar包文件

```
docker run -d -p 8081:8080 -v /opt/springboot-docker-1.0.jar:/var/lib/docker/jar/springboot-docker-1.0.jar --name springboot java:8u111 java -jar /var/lib/docker/jar/springboot-docker-1.0.jar
```

> -d 表示在后台启动
>
> -p 8081:8080 表示将容器的端口 映射成宿主主机的端口，否则9090端口访问不到
>
> -v /opt/springboot-docker-1.0.jar:/var/lib/docker/jar/springboot-docker-1.0.jar
>
> 表示将宿主主机的jar文件，映射到容器中（分号前为宿主主机的路径就是服务器的路径，分号后为容器中的路径）
>
> --name springboot
>
> 表示为该容器取一个全局唯一的名称，这里我取的名称为springboot
>
> java:8u111 表示镜像文件的名称和tag
>
> java -jar /var/lib/docker/jar/springboot-docker-1.0.jar
>
> 表示运行jar包，注意：这里的jar包为容器中的位置，是通过前面的-v属性映射的

* ### docker执行容器外部的war文件



