# docker应用：异常总结

1.centos6.5运行命令yum install docker.io，发生错误  _** No package docker available**_

解决方式：

```
yum install epel-release
```

运行上面的命令后，在执行 yum install docker.io或yum install docker

2.yum提示Another app is currently holding the yum lock; waiting for it to exit...

解决方式：

方式一

```
# kill -s 9 25960
# ps aux|grep yum
root      6744  0.0  0.0 103260   900 pts/1    S+   14:59   0:00 grep yum
root     25960  0.0  0.0      0     0 ?        Z    Sep19   0:01 [yumBackend.py] <defunct>
```

方式二

```
rm -f /var/run/yum.pid
```





