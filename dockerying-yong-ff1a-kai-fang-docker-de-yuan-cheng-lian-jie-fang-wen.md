# docker应用：开放docker的远程连接访问

* **方法一、方法二**

关于docker设置远程ip可以看看下面的，0.0.0.0是所有的都可以访问不安全，指定网卡ip，只能通过指定网卡的进行访问，这里10.14.0.1是自己搭建的局域网，该ip是主机自己的ip，这里只能设置自己网卡的ip不是设置远程访问地方的ip，如果设置成远程访问的是启动不了的

![](/assets/86d6277f9e2f0708db93060be524b899a901f223.jpg)

![](/assets/12312321321.png)



* **方法三**

1.

vi /usr/lib/systemd/system/docker.service

修改ExeStart为:/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock

重新加载配置并重启Docker：

systemctl daemon-reload

systemctl restart docker

2.

开放防火墙2375端口：

/sbin/iptables -I INPUT -p tcp --dport 2375 -j ACCEPT

iptables-save

OK,至此服务器端配置完成.

