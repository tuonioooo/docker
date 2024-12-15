# Docker MySql进阶配置

## MySQL(5.7.19)安装（⭐️⭐️⭐️）
最新官方MySQL(5.7.19)的docker镜像在创建时映射的配置文件目录有所不同，在此记录并分享给大家：

官方原文：

The MySQL startup configuration is specified in the file `/etc/mysql/my.cnf`, and that file in turn includes any files found in the `/etc/mysql/conf.d` directory that end with `.cnf`. Settings in files in this directory will augment and/or override settings in `/etc/mysql/my.cnf`. If you want to use a customized MySQL configuration, you can create your alternative configuration file in a directory on the host machine and then mount that directory location as `/etc/mysql/conf.d` inside the `mysql` container.

大概意思是说：

MySQL(5.7.19)的默认配置文件是 /etc/mysql/my.cnf 文件。如果想要自定义配置，建议向 /etc/mysql/conf.d 目录中创建 .cnf 文件。新建的文件可以任意起名，只要保证后缀名是 cnf 即可。新建的文件中的配置项可以覆盖 /etc/mysql/my.cnf 中的配置项。

具体操作：

首先需要创建将要映射到容器中的目录以及.cnf文件，然后再创建容器

```shell
mkdir -p docker_v/mysql/conf
cd docker_v/mysql/conf
touch my.cnf
docker run -p 3306:3306 --name mysql -v /opt/docker_v/mysql/conf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=123456 -d imageID
4ec4f56455ea2d6d7251a05b7f308e314051fdad2c26bf3d0f27a9b0c0a71414
```

:::color1
**参数说明：**

+ -p 3306:3306：**将容器的`3306`端口映射到主机的`3306`端口
+ -v /opt/docker_v/mysql/conf:/etc/mysql/conf.d：**将主机/opt/docker_v/mysql/conf目录挂载到容器的/etc/mysql/conf.d
+ -e MYSQL_ROOT_PASSWORD=123456：**初始化root用户的密码
+ -d imageID: 后台运行容器，imageID: mysql镜像ID

:::

**查看容器运行情况**

```shell
# docker ps
CONTAINER ID IMAGE          COMMAND          ... PORTS                    NAMES
4ec4f56455ea c73c7527c03a  "docker-entrypoint.sh" ... 0.0.0.0:3306->3306/tcp   mysql
```

## MySQL(5.7.19)安装高级写法（⭐️⭐️⭐⭐️）
下载MySQL`5.7`的docker镜像：

```shell
docker pull mysql:5.7
```

文件夹创建的过程忽略...

使用如下命令启动MySQL服务：

```shell
docker run -p 3306:3306 --name mysql \
-e MYSQL_ROOT_PASSWORD=root  \
-v /mydata/mysql/log:/var/log/mysql \
-v /mydata/mysql/data:/var/lib/mysql \
-v /mydata/mysql/conf:/etc/mysql \
-d mysql:5.7 
--lower-case-table-names=1 \
```

:::color1
**参数说明：**

+ -p 3306:3306：将容器的`3306`端口映射到主机的`3306`端口
+ -e MYSQL_ROOT_PASSWORD=root： #初始化root用户的密码
+ -v /mydata/mysql/conf:/etc/mysql： #将配置文件夹挂在到主机
+ -v /mydata/mysql/log:/var/log/mysql： #将日志文件夹挂载到主机
+ -v /mydata/mysql/data:/var/lib/mysql/： #将数据文件夹挂载到主机
+ `--lower-case-table-names=1` #忽略数据表名大小写

:::

:::color4
**注意：**

--lower-case-table-names=1

该属性只有初始化构建时才生效，my.cnf无法覆盖，如果没有设置的话，需要重新配置mysql才可以且记要备份挂载的数据文件，否则会死的很惨

:::

进入运行MySQL的docker容器：

```shell
docker exec -it mysql /bin/bash
```

使用MySQL命令打开客户端：

```shell
mysql -uroot -proot --default-character-set=utf8
```

创建一个账号并授予远程登录权限，使得任何ip都能访问：

```shell
CREATE USER 'reader'@'%' IDENTIFIED WITH mysql_native_password BY 'Lzslov123!';
GRANT ALL PRIVILEGES ON *.* TO 'reader'@'%';
flush privileges;
```

## MySql8安装（⭐️⭐️⭐️⭐️⭐️）
#### 下载 、简单运行
```shell
# docker 中下载 mysql
docker pull mysql

# 查看mysql镜像
docker images mysql
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
mysql        8         3218b38490ce   22 months ago   516MB

#启动
docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=your_pwd -d mysql
```

#### 无需手动配置.cnf文件，启动时设置相应的参数和挂载文件
```shell
docker run -p 3306:3306 --name test_mysql \
--privileged=true \
-e MYSQL_ROOT_PASSWORD=root \
-v /mnt/data2/mysql/data:/var/lib/mysql \
-v /mnt/data2/mysql/log:/var/log/mysql \
-d mysql:8 \
--character-set-server=utf8mb4 \
--collation-server=utf8mb4_unicode_ci \
--lower-case-table-names=1
```

:::info
**参数说明：**  
`--privileged=true`#启动时拥有root 相关的特权，注意位置不用放到 mysql:8 的后面  
`lower-case-table-names`#忽略数据表明大小写, 只能首次初始化设置有效，如果你首次没有加此参数，第二次加的话会报错并且 my.cnf无法覆盖，解决方式：需要重新配置mysql，删除原有的数据库挂载目录且要备份挂载的数据文件，否则会死的很惨  
`-e MYSQL_ROOT_PASSWORD=<root_password> `# 初始化root用户的密码

`-v /mnt/data2/mysql/data:/var/lib/mysql`# 挂载数据目录  
`-v /mnt/data2/mysql/log:/var/log/mysql`# 挂载日志目录  
`--character-set-server=utf8mb4`#设置服务器的字符集  
`--collation-server=utf8mb4_0900_ai_ci`# 设置服务器的排序规则

:::

#### 手动配置.cnf文件，启动时必须先上传配置文件，创建相应挂载的数据文件、日志文件、配置文件
[my.cnf详细配置含有官网对应的索引目录](https://github.com/tuonioooo/docker/blob/master/assets/mysql/my.cnf.md)<font style="color:rgb(31, 35, 40);">  
</font>[my.cnf初始配置](https://github.com/tuonioooo/docker/blob/master/assets/mysql/my.cnf)

+ 设置忽略表名大小写
+ 关闭了binlog日志
+ 设置了一些相关的字符集

docker启动创建mysql容器

```shell
docker run -p 3306:3306 --name test_mysql \
--privileged=true \
-e MYSQL_ROOT_PASSWORD=root \
-v /mnt/data2/mysql/data:/var/lib/mysql \
-v /mnt/data2/mysql/conf.d:/etc/mysql/conf.d \
-v /mnt/data2/mysql/log:/var/log/mysql \
-d mysql:8
```

:::info
**参数说明：**  
`--privileged=true` 启动时拥有root 相关的特权，注意位置不用放到 mysql:8 的后面  
`lower-case-table-names` 忽略数据表明大小写, 只能首次初始化设置有效，如果你首次没有加此参数，第二次加的话会报错并且 my.cnf无法覆盖，解决方式：需要重新配置mysql，删除原有的数据库挂载目录且要备份挂载的数据文件，否则会死的很惨  
`-e MYSQL_ROOT_PASSWORD=<root_password> ` # 初始化root用户的密码  
`-v /mnt/data2/mysql/data:/var/lib/mysql` # 挂载数据目录  
`-v /mnt/data2/mysql/conf.d:/etc/mysql/conf.d` # 挂载配置文件目录  
`-v /mnt/data2/mysql/log:/var/log/mysql` # 挂载日志目录

:::

#### docker同镜像安装多mysql服务
只需设置 `容器名字` 和 `主机映射端口`不同即可启动多个mysql服务，具体如下：

```shell
docker run -p 33306:3306 --name test_mysql \
--privileged=true \
-e MYSQL_ROOT_PASSWORD=root \
-v /mnt/data2/mysql/data:/var/lib/mysql \
-v /mnt/data2/mysql/conf.d:/etc/mysql/conf.d \
-v /mnt/data2/mysql/log:/var/log/mysql \
-d mysql:8
```

安装、参数详解略

#### 初始化后修改root密码
```shell
#进入mysql容器
docker exec -it mysql bash

#登录mysql
mysql -uroot -p'root'

#查询用户相关信息
select user, host, authentication_string from user;

#修改 root 密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'youpassord';

exit;

#重新登录
mysql -uroot -p'youpassord'
```

#### 授权用户远程登录的权限
```shell
#进入mysql容器
docker exec -it mysql bash

#登录mysql
mysql -u root -p'youpassord'

#授予root远程登录权限
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
flush privileges;

#添加一个新的用户，并授予远程登录的权限
CREATE USER 'tuonioooo'@'%' IDENTIFIED WITH mysql_native_password BY 'Lzslov123!';
GRANT ALL PRIVILEGES ON *.* TO 'tuonioooo'@'%';
flush privileges;
```

