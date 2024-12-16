# Docker Nginx进阶配置

### 进阶一
创建一个mydata文件夹

```shell
[root@localhost ~]# mkdir -p /mydata/nginx/conf
[root@localhost ~]# mkdir -p /mydata/nginx/logs
[root@localhost ~]# mkdir -p /mydata/nginx/html
[root@localhost ~]# mkdir -p /mydata/nginx/conf.d
```

> [!NOTE]
>
> **命令说明：**  
> mkdir -p /mydata/nginx/conf #存放配置文件入口文件  
> mkdir -p /mydata/nginx/logs #存放日志文件  
> mkdir -p /mydata/nginx/html #存放静态文件 可以动态注入自己的静态页面  
> mkdir -p /mydata/nginx/conf.d #存放多个配置文件（相当于vhost）

先运行一次容器（为了拷贝配置文件）：

```shell
docker run --name nginx-test -p 8080:80 -d nginx
```

将容器内的配置文件复制到主机目录上

```shell
[root@localhost ~]# docker container cp nginx-test:/etc/nginx/nginx.conf /mydata/nginx/conf
[root@localhost ~]# docker container cp nginx-test:/etc/nginx/conf.d/default.conf /mydata/nginx/conf.d
[root@localhost ~]# docker container cp nginx-test:/usr/share/nginx/html /mydata/nginx
```

> [!NOTE]
>
> **命令说明：**
>
> **1.映射配置文件入口文件 **
>
> **将容器入口文件 **nginx-test:/etc/nginx/nginx.conf ** 映射到 宿主主机中 **/mydata/nginx/conf 
>
> docker container cp nginx-test:/etc/nginx/nginx.conf /mydata/nginx/conf 
>
> **2.映射配置文件 **
>
> **将容器配置文件 **nginx-test:/etc/nginx/conf.d/default.conf 映射到 **宿主主机文件 **/mydata/nginx/conf.d 
>
> docker container cp nginx-test:/etc/nginx/conf.d/default.conf /mydata/nginx/conf.d 
>
> **3.映射静态目录 **
>
> **将容器目录 **nginx-test:/usr/share/nginx/html  映射到 **宿主主机目录 **/mydata/nginx
>
> docker container cp nginx-test:/usr/share/nginx/html /mydata/nginx

终止并删除容器：

```shell
docker stop nginx-test
docker rm nginx-test
```

创建新的Nginx容器，并映射本地文件

```shell
docker run -p 8080:80 --name nginx-test \
-v /mydata/nginx/html:/usr/share/nginx/html \
-v /mydata/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf  \
-v /mydata/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /mydata/nginx/logs:/var/log/nginx  \
--privileged=true \
-d nginx
```

> [!NOTE]
>
> **参数说明：**
>
> -p 8080:80 主机端口: 容器端口
>
> --name 容器名称
>
> -v /mydata/nginx/html:/usr/share/nginx/html \ (映射静态文件)
>
> -v /mydata/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf \ (映射配置文件)
>
> -v /mydata/nginx/conf/nginx.conf:/etc/nginx/nginx.conf (映射配置文件入口文件)
>
> -v /mydata/nginx/logs:/var/log/nginx \ (映射日志文件)
>
> -d nginx （后台运行nginx镜像）
>
> --privileged=true （容器以root权限运行）

