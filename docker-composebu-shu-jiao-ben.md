# docker compose部署脚本&服务编排

* [docker-compose常用命令](./docker-compose/docker-compose常用命令.md)
* [docker-compose安装jenkins](./docker-compose/docker-compose安装jenkins.md)
* [docker-compose安装mySql](./docker-compose/docker-compose安装mySql.md)
* [docker-compose安装nginx](./docker-compose/docker-compose安装nginx.md)
* [docker-compose安装redis](./docker-compose/docker-compose安装redis.md)
* [docker-compose编排多服务](./docker-compose/docker-compose编排多服务.md)

## 参考

### 菜鸟教程（基础）：

https://www.runoob.com/docker/docker-compose.html

### 官方文档：

#### 安装
[https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

[https://docs.docker.com/compose/compose-file/](https://docs.docker.com/compose/compose-file/)

#### compose命令规则

[https://docs.docker.com/compose/reference/](https://docs.docker.com/compose/reference/)


#### compose yml命令配置规则

```docker
version: '' # 版本
servers:  # 服务
  服务1: web
     # 服务的配置
     build
     network
     images
  服务2: redis
  服务3:
  服务4:
  ...
# 其他配置 网络，全局的规则 数据卷
volumes:
configs:
networks:
```

[https://docs.docker.com/compose/compose-file/ (命令行)](https://docs.docker.com/compose/compose-file/ (命令行))

[https://docs.docker.com/compose/compose-file/compose-file-v3/](https://docs.docker.com/compose/compose-file/compose-file-v3/)

[https://docs.docker.com/compose/compose-file/#links](https://docs.docker.com/compose/compose-file/#links)

[https://docs.docker.com/compose/compose-file/#external_links](https://docs.docker.com/compose/compose-file/#external_links)


### 第三方博客

[https://blog.csdn.net/pushiqiang/article/details/78682323](https://blog.csdn.net/pushiqiang/article/details/78682323)

[https://www.cnblogs.com/antflow/p/7289704.html](https://www.cnblogs.com/antflow/p/7289704.html)

[https://www.macrozheng.com/mall/deploy/mall_deploy_docker_compose.html（mall商城部署进阶）](https://www.macrozheng.com/mall/deploy/mall_deploy_docker_compose.html（mall商城部署进阶）)

[https://www.kancloud.cn/zatko/docker/2291357](https://www.kancloud.cn/zatko/docker/2291357)




