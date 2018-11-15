# docker应用：开放docker的远程连接访问

1.

vi /usr/lib/systemd/system/docker.service

修改ExeStart为:/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock

重新加载配置并重启Docker:

systemctl daemon-reload 

systemctl restart docker

2.

开放防火墙2375端口:

/sbin/iptables -I INPUT -p tcp --dport 2375 -j ACCEPT

iptables-save

OK,至此服务器端配置完成.

