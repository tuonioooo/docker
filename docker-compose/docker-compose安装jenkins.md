# docker-compose部署jenkins

### 安装docker-compose 

菜鸟教程（基础，很详细）：

https://www.runoob.com/docker/docker-compose.html

官方文档教程：

[https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

### 编写docker-compose.yml文件

```
version: '3' #指定版本
services:    #服务根节点
  jenkins:   #jenkins服务/其他服务（web服务/nginx服务等）
    image: jenkins/jenkins:lts  #jenkins镜像，如果镜像容器没有会去自动拉取
    container_name: jenkins     #容器的名称
    user: root                  #容器使用的用户
    privileged: true            #授予root权限  
    restart: always             #跟随docker的启动而启动
    environment:                #设置命令执行的环境变量
        JAVA_OPTS: '-Djava.util.logging.config.file=/var/jenkins_home/log.properties'  #设置Java运行时JVM所需参数变量，修改日志输出的格式
    volumes:                    #挂载卷命令
      - /mydata/jenkins/:/var/jenkins_home                              #将默认/var/jenkins_home 挂载到宿主主机上 /data/jenkins/
      - /usr/local/apache-maven-3.8.6:/usr/local/apache-maven-3.8.6     #宿主主机maven挂载到容器目录上
      - /usr/local/java/jdk1.8.0_341:/usr/local/java/jdk1.8.0_341       #宿主主机jdk挂载到容器目录上
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
      - /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7
    ports:
      - 8088:8080    #映射容器端口8080 到 宿主机端口8080
    expose:          #暴露给其他容器、link的端口号
      - 8080
      - 50000
```

### 部署jenkins
将 `docker-compose.yml` 文件上传到Linux服务器 `/mydata` 目录下，目录请自建
```
$ cd /mydata
$ docker-compose up -d  #后台运行
[+] Running 1/1
 ⠿ Container jenkins  Started   
```

### 常用命令

[docker-compose常用命令](docker-compose常用命令.md)


