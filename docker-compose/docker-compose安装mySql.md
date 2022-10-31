# docker-compose安装mySql

### 安装docker-compose

菜鸟教程（基础，很详细）：

https://www.runoob.com/docker/docker-compose.html

官方文档教程：

[https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

### 编写docker-compose.yml文件

```docker
version: '3'
services:
  mysql:                                            #mysql服务节点
    image: mysql:5.7                                #mysql镜像，如果镜像容器没有会去自动拉取
    container_name: mysql                           #容器的名称
    command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci #构建容器后所执行的命令
    restart: always                                 #跟随docker的启动而启动
    environment:
      MYSQL_ROOT_PASSWORD: root                     #设置root帐号密码
    ports:
      - 3306:3306
    volumes:
      - /mydata/mysql/data:/var/lib/mysql           #数据文件挂载
      - /mydata/mysql/conf.d:/etc/mysql/conf.d      #配置文件挂载
      - /mydata/mysql/log:/var/log/mysql            #日志文件挂载
```

### 部署

#### 准备工作

创建目录

```docker
$ mkdir -p /mydata/mysql/data/db \
 -p /mydata/mysql/data/conf \
 -p /mydata/mysql/log
```


> 说明: 
> 最新官方MySQL(5.7.19)的docker镜像在创建时映射的配置文件目录有所不同
> MySQL(5.7.19)的默认配置文件是 `/etc/mysql/my.cnf` 文件。如果想要自定义配置，
> 建议向 `/etc/mysql/conf.d` 目录中创建 `*.cnf` 文件。新建的文件可以任意起名，只要保证后缀名是 cnf 即可。
> 新建的文件中的配置项可以覆盖 `/etc/mysql/my.cnf` 中的配置项。
> 又由于宿主主机 `/mydata/mysql/conf.d` 目录 已经挂载到docker容器 `/etc/mysql/conf.d` 目录，所以只需在 `/mydata/mysql/conf.d` 目录下自定义*.cnf文件即可生效。


将 `docker-compose.yml` 文件上传到Linux服务器 `/mydata` 目录下

#### 启动mysql

```
$ cd /mydata
$ docker-compose up mysql -d  #指定mysql 后台运行
[+] Running 1/1
 ⠿ Container mysql  Started   
```

验证

```
docker exec -it mysql  mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.7.36 MySQL Community Server (GPL)

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

```


### 常用命令

[docker-compose常用命令](docker-compose常用命令.md)
