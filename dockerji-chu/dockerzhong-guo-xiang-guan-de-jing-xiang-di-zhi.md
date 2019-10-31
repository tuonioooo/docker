# docker中国相关的镜像地址

### 阿里云加速

```
#vi  /etc/docker/daemon.json

{

"registry-mirrors": ["https://almtd3fa.mirror.aliyuncs.com"]

}
```

### 腾讯云加速

```
#vi  /etc/docker/daemon.json

{

"registry-mirrors": ["https://mirror.ccs.tencentyun.com"]

}
```

### 中国镜像加速

```
#vi  /etc/docker/daemon.json

{

"registry-mirrors": ["https://registry.docker-cn.com"]

}
```

清华镜像地址：[https://mirrors.tuna.tsinghua.edu.cn/](https://mirrors.tuna.tsinghua.edu.cn/)

