# docker应用：安装与卸载

## 前提

首先，你的Centos的系统一定要是64位的，不管版本是什么。并且内核版本至少是3.10以上。 

用以下命令去查看你的内核版本：

```
$ uname -r
3.10.0-229.el7.x86_64
```

最后，建议你更新你的系统，因为最新内核可能会修复了旧版本的一些bug。

## 用yum安装

用具有sudo或者root权限的用户登录系统。 

确保你的yum包已经更新。

```
$ sudo yum update
```

添加yum仓库

```
$ sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```

安装Docker包

```
$ sudo yum install docker-engine
```

开启docker deamon

```
$ sudo service docker start
```

验证docker是否成功安装

```
$ docker version
[root@localhost mnt]# docker pull hello-world
Using default tag: latest
latest: Pulling from library/hello-world
b04784fba78d: Pull complete 
Digest: sha256:f3b3b28a45160805bb16542c9531888519430e9e6d6ffc09d72261b0d26ff74f
Status: Downloaded newer image for hello-world:latest
[root@localhost mnt]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              1815c82652c0        2 months ago        1.84kB
```

## 卸载

列出你安装过的包

```
$ yum list installed | grep docker
docker-engine.x86_64   
1.7.1-1.el7 @/docker-engine-1.7.1-1.el7.x86_64.rpm
```

删除安装包

```
$ sudo yum -y remove docker-engine.x86_64
```

删除镜像/容器等

```
$ rm -rf /var/lib/docker
```

## 参考

原文：https://blog.csdn.net/qq\_34912469/article/details/77337122 



