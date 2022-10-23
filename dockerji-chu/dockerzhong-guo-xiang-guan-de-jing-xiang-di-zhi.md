# docker中国相关的镜像地址

### 阿里云加速

```
#vi  /etc/docker/daemon.json

{

"registry-mirrors": ["https://almtd3fa.mirror.aliyuncs.com"]

}
```

### 网易云加速

```
#vi  /etc/docker/daemon.json

{

"registry-mirrors": ["https://hub-mirror.c.163.com"]

}
```

### 百度云加速

```
#vi  /etc/docker/daemon.json

{

"registry-mirrors": ["https://mirror.baidubce.com"]

}
```

### 中国镜像加速

```
#vi  /etc/docker/daemon.json

{

"registry-mirrors": ["https://registry.docker-cn.com"]

}
```

# 修改保存后 运行一下命令 生效

```
[root@VM-0-5-centos ~]# systemctl daemon-reload
[root@VM-0-5-centos ~]# systemctl restart docker
```


清华镜像地址：[https://mirrors.tuna.tsinghua.edu.cn/](https://mirrors.tuna.tsinghua.edu.cn/)

