# Dockerfile为SpringBoot应用构建镜像

## 简介
本示例使用Dockerfile 相关命令，和已经打好包(`mvn -DskiptTests package`) 的SpringBoot 应用 在Docker服务器上构建镜像并启动的 简单示例。

[Dockerfile常用命令](https://github.com/tuonioooo/docker/blob/master/dockerfile-command.md)

## 编写Dockerfile文件
```dockerfile
# 该镜像需要依赖的基础镜像
FROM java:8
# 将当前目录下的jar包复制到docker容器的/目录下
ADD dockerfile-example-0.0.1-SNAPSHOT.jar /app.jar
# 运行过程中更改 `app.jar` 文件的访问时间和修改时间
RUN bash -c 'touch /app.jar'
# 声明服务运行在8080端口
EXPOSE 8802
# 指定docker容器启动时运行jar包
ENTRYPOINT ["java", "-jar","/app.jar"]
# 指定维护者的名字
MAINTAINER tuonioooo
```

## 使用maven打包应用
使用idea maven插件打包

![](https://github.com/tuonioooo/docker/raw/master/assets/dockerfile_04.png)

打包成功信息

```shell
INFO] --- spring-boot-maven-plugin:2.7.5:repackage (repackage) @ dockerfile-example ---
[WARNING] The POM for commons-codec:commons-codec:jar:1.11 is invalid, transitive dependencies (if any) will not be available, enable debug logging for more details
[WARNING] The POM for org.apache.commons:commons-lang3:jar:3.7 is invalid, transitive dependencies (if any) will not be available, enable debug logging for more details
[INFO] Replacing main artifact with repackaged archive
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  17.530 s
[INFO] Finished at: 2022-11-02T09:10:30+08:00
[INFO] ------------------------------------------------------------------------

Process finished with exit code 0
```

## 构建镜像
将Dockerfile、dockerfile-example-0.0.1-SNAPSHOT.jar 上传到Linux服务器上

![](https://github.com/tuonioooo/docker/raw/master/assets/dockerfile_05.png)

在Dockerfile所在目录执行以下命令：

```shell
docker build -t my_dfile/dockerfile-example:0.0.1-SNAPSHOT .
```

:::info
**参数说明：**

`-t` 表示指定镜像仓库名称/镜像名称:镜像标签 `.` 表示使用当前目录下的Dockerfile

:::

输出如下信息:

```shell
Sending build context to Docker daemon  1.265GB
Step 1/6 : FROM java:8
 ---> d23bdf5b1b1b
Step 2/6 : ADD dockerfile-example-0.0.1-SNAPSHOT.jar /app.jar
 ---> 13f7c5c6e419
Step 3/6 : RUN bash -c 'touch /app.jar'
 ---> Running in 1ef18ec6b2f0
Removing intermediate container 1ef18ec6b2f0
 ---> c6f62bc623d1
Step 4/6 : EXPOSE 8802
 ---> Running in ef33d28ed325
Removing intermediate container ef33d28ed325
 ---> a71ef4fc90d0
Step 5/6 : ENTRYPOINT ["java", "-jar","/app.jar"]
 ---> Running in a132f902ceeb
Removing intermediate container a132f902ceeb
 ---> 05287fa1fb5c
Step 6/6 : MAINTAINER tuonioooo
 ---> Running in 1d9405f6c813
Removing intermediate container 1d9405f6c813
 ---> ce44f6e0bb51
Successfully built ce44f6e0bb51
Successfully tagged my_dfile/dockerfile-example:0.0.1-SNAPSHOT
```

查看镜像

![](https://github.com/tuonioooo/docker/raw/master/assets/dockerfile_02.png)

## 启动
挂载日志目录

```shell
mkdir -p /mount/apps/dockerfile-example/logs
```

删除已存在的容器、和空悬镜像

```shell
docker stop dockerfile-01
docker rm dockerfile-01
docker rmi $(docker images -f "dangling=true" -q)
或
docker image prune
```

启动docker

```shell
docker run -p 8802:8802 --name dockerfile-01 \
  -v /etc/localtime:/etc/localtime \
  -v /mount/apps/dockerfile-example/logs:/logs \
  -d my_dfile/dockerfile-example:0.0.1-SNAPSHOT
```

进行访问测试，地址：[http://192.168.217.144:8802/swagger-ui.html](http://192.168.217.144:8802/swagger-ui.html)

![](https://github.com/tuonioooo/docker/raw/master/assets/dockerfile_03.png)

## 演示项目地址
[https://gitee.com/ecs-common-deploy/dockerfile-example.git](https://gitee.com/ecs-common-deploy/dockerfile-example.git)

