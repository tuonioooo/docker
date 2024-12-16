# docker-compose安装nginx

### docker-compose 安装

[docker-compose 安装](../usage/docker-compose.md)

### 编写docker-compose.yml文件

```yml
version: '3' #指定版本
services:    #服务根节点
  nginx:   #jenkins服务/其他服务（web服务/nginx服务等）
    image: nginx:1.22  #nginx镜像，如果镜像容器没有会去自动拉取
    container_name: nginx       #容器的名称
    restart: always             #跟随docker的启动而启动
    volumes:                    #挂载卷命令
      - /mydata/nginx/conf/nginx.conf:/etc/nginx/nginx.conf              #映射配置文件入口文件
      - /mydata/nginx/html:/usr/share/nginx/html                         #静态资源根目录挂载
      - /mydata/nginx/logs:/var/log/nginx                                #日志文件挂载
      - /mydata/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf #映射配置文件  
    ports:
      - 80:80    #宿主主机端口80 映射到 容器端口80
```

### 部署

#### 准备工作
Nginx 需要拷贝nginx配置文件、入口文件，否则挂载时会因为没有配置文件而启动失败。

创建目录&copy示例文件  

```shell
$ mkdir -p /mydata/nginx/
$ mkdir -p /mydata/nginx/logs
$ mkdir -p /mydata/nginx/html
$ mkdir -p /mydata/nginx/conf.d
```
nginx.conf文件上传到 `/mydata/nginx/` 目录下面

default.conf 文件上传到 `/mydata/nginx/conf.d/default.conf` 目录下面

index.html、50x.html 文件上传到 `/mydata/nginx/html` 目录下面

通用的配置文件模板 

* [nginx.conf](nginx/conf/nginx.conf)
* [default.conf](nginx/conf.d/default.conf)
* [index.html](nginx/html/index.html)
* [50x.html](nginx/html/50x.html)

> 说明：  
> 本示例将nginx包内所需的文件全部挂载到了宿主主机上，并且提供了对应的通用模板，在自身使用环境中，其实只需挂载
> * `/mydata/nginx/conf/nginx.conf:/etc/nginx/nginx.conf`  #映射配置文件入口文件  
> * `/mydata/nginx/logs:/var/log/nginx`                    #日志文件挂载  
> * `/mydata/nginx/html:/usr/share/nginx/html`             #静态资源根目录挂载  
> 因为配置文件、和静态资源的内容需要根据自身的情况在宿主主机上定义位置和内容，本示例为了方便演示提供了全部的模板

#### 启动nginx

将 `docker-compose.yml` 文件上传到Linux服务器 `/mydata` 目录下，

```
$ cd /mydata
$ docker-compose up -d  #后台运行
[+] Running 1/1
 ⠿ Container nginx  Started   
```

### 常用命令

[docker-compose常用命令](./docker-compose-common-command.md)
