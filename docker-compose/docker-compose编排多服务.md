# docker-compose编排多服务一体化脚本

## 说明
 
本教程基于docker-compose同时编排（部署）多个服务包含: jenkins、redis、mySql5、nginx。

一些相关命令备注:

* depend_on: 依赖服务启动的顺序  [https://docs.docker.com/compose/compose-file/#depends_on](https://docs.docker.com/compose/compose-file/#depends_on)
* 其他命令: [https://docs.docker.com/compose/compose-file/](https://docs.docker.com/compose/compose-file/)
  
## 准备工作

#### 搭建基础和依赖环境

* 搭建jdk环境请自行准备(本教程演示的挂载目录: /usr/local/java/jdk1.8.0_341)
* 搭建maven环境请自行准备(本教程演示的挂载目录: /usr/local/apache-maven-3.8.6)  
* 搭建git环境请自行准备  
* [安装docker](../dockeran-zhuang-yu-shi-yong.md)  
* [安装docker-compose](https://www.runoob.com/docker/docker-compose.html)  


#### 创建容器映射宿主主机挂载目录

* jenkins挂载目录

```docker
$ mkdir -p /mount/jenkins/
```

* mySql挂载目录

```docker
$ mkdir -p /mount/mysql/data \
  -p /mount/mysql/conf.d \
  -p /mount/mysql/log
```

> 说明: 
> 最新官方MySQL(5.7.19)的docker镜像在创建时映射的配置文件目录有所不同
> MySQL(5.7.19)的默认配置文件是 `/etc/mysql/my.cnf` 文件。如果想要自定义配置，
> 建议向 `/etc/mysql/conf.d` 目录中创建 `*.cnf` 文件。新建的文件可以任意起名，只要保证后缀名是 cnf 即可。
> 新建的文件中的配置项可以覆盖 `/etc/mysql/my.cnf` 中的配置项。
> 又由于宿主主机 `/mount/mysql/conf.d` 目录 已经挂载到docker容器 `/etc/mysql/conf.d` 目录，所以只需在 `/mount/mysql/conf.d` 目录下自定义*.cnf文件即可生效。

* nginx挂载目录

```docker
$ mkdir -p /mount/nginx/conf \
  -p /mount/nginx/logs \
  -p /mount/nginx/html \
  -p /mount/nginx/conf.d
```

nginx.conf文件上传到 `/mount/nginx/` 目录下面

default.conf 文件上传到 `/mount/nginx/conf.d/default.conf` 目录下面

index.html、50x.html 文件上传到 `/mount/nginx/html` 目录下面

通用的配置文件模板 

[nginx.conf](nginx/conf/nginx.conf)  
[default.conf](nginx/conf.d/default.conf)  
[index.html](nginx/html/index.html)  
[50x.html](nginx/html/50x.html)  

> 说明: 
> 映射的配置文件一定要存在，否则启动服务会报错

* redis挂载目录

```docker
$ mkdir -p /mount/redis/data
```


## 编写docker-compose.yml文件

```docker
version: '3'
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    user: root
    privileged: true
    restart: always
    environment:
        JAVA_OPTS: '-Djava.util.logging.config.file=/var/jenkins_home/log.properties'
    volumes:
      - /mount/jenkins/:/var/jenkins_home 
      - /usr/local/apache-maven-3.8.6:/usr/local/apache-maven-3.8.6
      - /usr/local/java/jdk1.8.0_341:/usr/local/java/jdk1.8.0_341
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
      - /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7
    ports:
      - 8088:8080
    expose:
      - 8080
      - 50000
  nginx:
    image: nginx:latest
    container_name: nginx
    restart: always 
    volumes: 
      - /mount/nginx/conf/nginx.conf:/etc/nginx/nginx.conf   
      - /mount/nginx/html:/usr/share/nginx/html             
      - /mount/nginx/logs:/var/log/nginx                    
      - /mount/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf  
    ports:  
      - 80:80   
  redis: 
    image: redis:latest  
    container_name: redis  
    command: redis-server --appendonly yes --requirepass '123456'  
    restart: always  
    volumes:  
      - /mount/redis/data:/data  
    ports:   
      - 6379:6379
  mysql:     
    image: mysql:5.7                                
    container_name: mysql                           
    command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci 
    restart: always                                 
    environment:  
      MYSQL_ROOT_PASSWORD: root          
    ports:    
      - 3306:3306
    volumes:   
      - /mount/mysql/data:/var/lib/mysql
      - /mount/mysql/conf.d:/etc/mysql/conf.d
      - /mount/mysql/log:/var/log/mysql
```

## 部署

将 `docker-compose.yml` 文件上传到Linux服务器 `/mount` 目录下  

启动脚本服务  

```docker
$ cd /mount
$ docker-compose up -d  #后台运行
[+] Running 4/4
 ⠿ Container nginx    Started                                                                               2.6s
 ⠿ Container redis    Started                                                                               2.6s
 ⠿ Container mysql    Started                                                                               2.7s
 ⠿ Container jenkins  Started                                                                               2.6s
```

验证过程略
