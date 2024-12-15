# docker-compose 部署jenkins

### docker-compose 安装

[docker-compose 安装](../manual/docker-compose-run-command.md)

### 设置宿主机目录权限，方便于容器映射

#### 说明: 下面将会介绍两种挂载的方式

* 第一种 在宿主主机 安装好java环境、maven环境（PS：请提前配置好settings.xml 仓库目录为 `/mydata/maven/repository`），启动容器时挂载到容器内部，在jenkins配置时无需额外的自动安装java环境、maven环境，只需要指定java、maven目录即可（因为已经通过宿主主机挂载到容器内部，即使删除容器也不用担心数据丢失的问题）

```
mkdir -p /mydata/jenkins                    #在宿主主机中创建挂载jenkins工作目录
mkdir -p /mydata/maven/repository           #在宿主主机中创建挂载maven仓库目录
chown -R 1000:1000 /mydata/jenkins          #授予权限
chown -R 1000:1000 /mydata/maven/repository
chown -R 1000:1000 /usr/local/src/jdk/jdk1.8/
chown -R 1000:1000 /usr/local/apache-maven-3.8.6/
```


> 命令说明：需要修改映射的目录权限，因为当映射本地数据卷时，/mydata/jenkins/目录的拥有者为root用户，
> 而容器中jenkins用户的 uid 为 1000。

* 第二种 在jenkins容器中（自动安装java环境、maven环境)，启动容器时挂载到宿主主机目录（避免数据丢失）

```
mkdir -p /mydata/jenkins                    #在宿主主机中创建挂载jenkins工作目录
chown -R 1000:1000 /mydata/jenkins          #授予权限
```
> 命令说明: 参考第一种  
> 在宿主主机中创建挂载容器jenkins工作目录，目录中的所有文件都会自动挂载到宿主主机中。  
> 容器jenkins工作目录简单介绍:   
> * `/var/jenkins_home/tools` 自动安装插件  
> * `/var/jenkins_home/.m2/repository` 自动下载maven依赖jar  



### 编写docker-compose.yml文件

* 第一种 需要宿主主机自备maven环境、java环境，安装过程略，提前配置settings.xml  `/mydata/maven/repository` 仓库目录地址

```yml
version: '3' #指定版本
services:    #服务根节点
  jenkins:   #jenkins服务/其他服务（web服务/nginx服务等）
    image: jenkins/jenkins:lts  #jenkins镜像，如果镜像容器没有会去自动拉取
    container_name: jenkins     #容器的名称
    user: root                  #容器使用的用户
    #user: 1000:993             #uid=1000(daizhao) gid=1000(daizhao) 组=1000(daizhao),993(docker) 使用uid代替username 避免报错Error response from daemon: unable to find user ubuntuu: no matching entries in passwd file
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

```yml
version: '3' #指定版本
services:    #服务根节点
  jenkins:   #jenkins服务/其他服务（web服务/nginx服务等）
    image: jenkins/jenkins:lts  #jenkins镜像，如果镜像容器没有会去自动拉取
    container_name: jenkins     #容器的名称
    user: root                  #容器使用的用户
    #user: 1000:993                #uid=1000(daizhao) gid=1000(daizhao) 组=1000(daizhao),993(docker) 使用uid代替username 避免报错Error response from daemon: unable to find user ubuntuu: no matching entries in passwd file
    privileged: true            #授予root权限  
    restart: always             #跟随docker的启动而启动
    environment:                #设置命令执行的环境变量
        JAVA_OPTS: '-Djava.util.logging.config.file=/var/jenkins_home/log.properties'  #设置Java运行时JVM所需参数变量，修改日志输出的格式
    volumes:                    #挂载卷命令
      - /mydata/jenkins/:/var/jenkins_home                             #将默认/var/jenkins_home 挂载到宿主主机上 /data/jenkins/
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

> 说明:   
> user 用法:  
> 官网：[https://docs.docker.com/compose/compose-file/#user](https://docs.docker.com/compose/compose-file/#user)
> user: 1000:993  （指定docker组） #使用创建的用户 操作jenkins相关命令 `uid=1000(daizhao) gid=1000(daizhao) 组=1000(daizhao),993(docker)` 使用uid:gid代替username 避免报错Error response from daemon: unable to find user ubuntuu: no matching entries in passwd file  
> 必须指定 uid或者gid 否则会导致 jenkins执行相关docker命令 报 `java.io.IOException: Permission denied`
> 或 user: 1000:1000  （指定daizhao组）
> 或 user: root (以root用户身份操作jenkins, 无需指定uid:gid，直接username 即可)

### 部署

将 `docker-compose.yml` 文件上传到Linux服务器 `/mydata` 目录下，目录请自建

```
$ cd /mydata
$ docker-compose up -d  #后台运行
[+] Running 1/1
 ⠿ Container jenkins  Started   
```

### 常用命令

[docker-compose常用命令](./docker-compose-common-command.md)
