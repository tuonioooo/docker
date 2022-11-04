# docker-compose部署jenkins

### 安装docker-compose

菜鸟教程（基础，很详细）：

https://www.runoob.com/docker/docker-compose.html

官方文档教程：

[https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

### 设置宿主机目录权限，方便于容器映射

#### 说明: 下面将会介绍两种挂载的方式

* 第一种 在宿主主机 安装好java环境、maven环境（PS：请提前配置好settings.xml 仓库目录为 `/mydata/maven/repository`），启动容器时挂载到容器内部，在jenkins配置时无需额外的自动安装java环境、maven环境，只需要指定java、maven目录即可（因为已经通过宿主主机挂载到容器内部，即使删除容器也不用担心数据丢失的问题）

```
mkdir -p /mydata/jenkins                    #在宿主主机中创建挂载目录
mkdir -p /mydata/maven/repository           #在宿主主机中创建挂载目录
chown -R 1000:1000 /mydata/jenkins          #授予权限
chown -R 1000:1000 /mydata/maven/repository
chown -R 1000:1000 /usr/local/src/jdk/jdk1.8/
chown -R 1000:1000 /usr/local/apache-maven-3.8.6/
```


> 参数说明：需要修改映射的目录权限，因为当映射本地数据卷时，/mydata/jenkins/目录的拥有者为root用户，
> 而容器中jenkins用户的 uid 为 1000。

* 第二种 在jenkins容器中（自动安装java环境、maven环境)，启动容器时挂载到宿主主机目录（避免数据丢失）

```
mkdir -p /mydata/jenkins                    #在宿主主机中创建挂载目录
mkdir -p /mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/repository #在宿主主机中创建maven仓库挂载目录
chown -R 1000:1000 /mydata/jenkins          #授予权限
```
> 参数说明: 参考第一种  
> 在jenkins容器内部安装软件时，会自动安装到 `/var/jenkins_home/tools/` 这个目录，又因为我们已经打算通过 `-v /mydata/jenkins/:/var/jenkins_home` 挂载目录，所以自动安装的软件将会自动挂载到宿主主机中
> 但我们需要额外的配置一下 仓库的地址来映射 宿主主机目录 避免容器删除时，仓库数据丢失。  
> 容器内部目录 `/var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/conf/settings.xml`  
> 挂载宿主主机目录 `/mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/conf/settings.xml`  
> 所以只需修改 `/mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/conf/settings.xml` 配置文件即可  
> 这里仓库是映射到 `/mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/repository`

### 编写docker-compose.yml文件

* 第一种 需要宿主主机自备maven环境、java环境，安装过程略，提前配置settings.xml  `/mydata/maven/repository` 仓库目录地址

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
      - /mydata/maven/repository:/mydata/maven/repository               #宿主主机maven仓库目录挂载到容器目录上
      - /usr/local/java/jdk1.8.0_341:/usr/local/java/jdk1.8.0_341       #宿主主机jdk挂载到容器目录上
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/localtime:/etc/localtime                                  #同步时间
      - /usr/bin/docker:/usr/bin/docker
      - /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7
    ports:
      - 8088:8080    #映射容器端口8080 到 宿主机端口8080
    expose:          #暴露给其他容器、link的端口号
      - 8080
      - 50000
```

* 第二种 在jenkins容器中（自动安装java环境、maven环境)，启动容器时挂载到宿主主机目录（避免数据丢失）

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
      - /mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/repository:/root/.m2/repository
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/localtime:/etc/localtime                                  #同步时间
      - /usr/bin/docker:/usr/bin/docker
      - /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7
    ports:
      - 8088:8080    #映射容器端口8080 到 宿主机端口8080
    expose:          #暴露给其他容器、link的端口号
      - 8080
      - 50000
```


### 部署

将 `docker-compose.yml` 文件上传到Linux服务器 `/mydata` 目录下，目录请自建

```
$ cd /mydata
$ docker-compose up -d  #后台运行
[+] Running 1/1
 ⠿ Container jenkins  Started   
```

### 常用命令

[docker-compose常用命令](docker-compose常用命令.md)
