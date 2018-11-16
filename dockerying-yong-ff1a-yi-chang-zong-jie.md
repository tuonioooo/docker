# docker应用：异常总结

1.centos6.5运行命令yum install docker.io，发生错误  _** No package docker available**_

解决方式：

```
yum install epel-release
```

运行上面的命令后，在执行 yum install docker.io或yum install docker

