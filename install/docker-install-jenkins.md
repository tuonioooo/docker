# Docker 安装 Jenkins
### 1、查看可用的 jenkins 版本
访问 jenkins 镜像库地址： [https://hub.docker.com/_/jenkins?tab=tags](https://hub.docker.com/_/jenkins?tab=tags) 。

可以通过 Sort by 查看其他版本的 jenkins，默认是最新版本 **jenkins:latest**。

![](https://github.com/tuonioooo/docker/raw/master/assets/jenkins_Snipaste_2022-10-30_17-04-50.png)

此外，我们还可以用 docker search jenkins 命令来查看可用版本：

```shell
NAME                           DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
jenkins                        DEPRECATED; use "jenkins/jenkins:lts" instead   5560      [OK]
jenkins/jenkins                The leading open source automation server       3261
jenkins/jnlp-slave             a Jenkins agent which can connect to Jenkins…   151                  [OK]
jenkins/inbound-agent                                                          78
bitnami/jenkins                Bitnami Docker Image for Jenkins                54                   [OK]
jenkins/slave                  base image for a Jenkins Agent, which includ…   48                   [OK]
jenkins/agent                                                                  46
jenkins/ssh-slave              A Jenkins slave using SSH to establish conne…   38                   [OK]
jenkins/ssh-agent              Docker image for Jenkins agents connected ov…   27
jenkins/jnlp-agent-docker                                                      8
jenkins/jnlp-agent-maven       A JNLP-based agent with Maven 3 built in        7
jenkins/pct                    Plugin Compat Tester                            5                    [OK]
jenkins/evergreen              An automatically self-updating Jenkins distr…   5
jenkins/jnlp-agent-python      A JNLP-based agent with Python built in         3
jenkins/jenkins-experimental   Experimental images of Jenkins. These images…   3                    [OK]
jenkins/jnlp-agent-alpine                                                      2
jenkins/jnlp-agent-coresdk                                                     2
rancher/jenkins-jenkins                                                        1
jenkins/jnlp-agent-node                                                        1
jenkins/jenkinsfile-runner     Jenkinsfile Runner packages                     1
jenkins/core-pr-tester         Docker image for testing pull-requests sent …   1
jenkins/ath                    Jenkins Acceptance Test Harness                 1                    [OK]
jenkins/jnlp-agent-ruby                                                        1
rancher/jenkins-slave          Jenkins Build Slave                             0                    [OK]
rancher/jenkins-jnlp-slave                                                     0
```

### 2、取长期支持版本的 jenkins 镜像
这里选择长期支持版本，下载完成后，查看镜像

```shell
$ docker pull jenkins/jenkins:lts
```

### 3、查看本地镜像
```shell
$ docker images
REPOSITORY        TAG       IMAGE ID       CREATED         SIZE
jenkins/jenkins   lts       2a4bbe50c40b   11 months ago   441MB
```

### 4、设置宿主机目录权限，方便于容器映射
#### 说明: 下面将会介绍两种挂载的方式
+ 第一种 在宿主主机 安装好java环境、maven环境（PS：请提前配置好settings.xml 仓库目录为 `/mydata/maven/repository`），启动容器时挂载到容器内部，在jenkins配置时无需额外的自动安装java环境、maven环境，只需要指定java、maven目录即可（因为已经通过宿主主机挂载到容器内部，即使删除容器也不用担心数据丢失的问题）

```shell
mkdir -p /mydata/jenkins                    #在宿主主机中创建挂载目录
mkdir -p /mydata/maven/repository           #在宿主主机中创建挂载目录
chown -R 1000:1000 /mydata/jenkins          #授予权限
chown -R 1000:1000 /mydata/maven/repository
chown -R 1000:1000 /usr/local/src/jdk/jdk1.8/
chown -R 1000:1000 /usr/local/apache-maven-3.8.6/
```

参数说明：需要修改映射的目录权限，因为当映射本地数据卷时，/mydata/jenkins/目录的拥有者为root用户， 而容器中jenkins用户的 uid 为 1000。

+ 第二种 在jenkins容器中（自动安装java环境、maven环境)，启动容器时挂载到宿主主机目录（避免数据丢失）

```shell
mkdir -p /mydata/jenkins                    #在宿主主机中创建挂载目录
mkdir -p /mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/repository #在宿主主机中创建maven仓库挂载目录
chown -R 1000:1000 /mydata/jenkins          #授予权限
```

:::info
**参数说明: **

参考第一种  
在jenkins容器内部安装软件时，会自动安装到 `/var/jenkins_home/tools/` 这个目录，又因为我们已经打算通过 `-v /mydata/jenkins/:/var/jenkins_home` 挂载目录，所以自动安装的软件将会自动挂载到宿主主机中 但我们需要额外的配置一下 仓库的地址来映射 宿主主机目录 避免容器删除时，仓库数据丢失。  
容器内部目录 `/var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/conf/settings.xml`  
挂载宿主主机目录 `/mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/conf/settings.xml`  
所以只需修改 `/mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/conf/settings.xml` 配置文件即可  
这里仓库是映射到 `/mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/repository`

:::

### 5、运行容器
#### jenkins手动安装maven、java环境，启动容器配置参数
```shell
$ docker run -p 8080:8080  \
  -v /mydata/jenkins/:/var/jenkins_home \
  -v /usr/local/apache-maven-3.8.6:/usr/local/apache-maven-3.8.6 \
  -v /mydata/maven/repository:/mydata/maven/repository \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  -v /etc/localtime:/etc/localtime \
  -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai \
  --restart "always" \
  -d jenkins/jenkins:lts
```

如果没有授权宿主主机目录的权限，可以使用授予root权限执行容器命令

```shell
docker run -p 8080:8080  \
  -v /mydata/jenkins/:/var/jenkins_home \
  -v /usr/local/apache-maven-3.8.6:/usr/local/apache-maven-3.8.6 \
  -v /mydata/maven/repository:/mydata/maven/repository \
  -v /etc/localtime:/etc/localtime \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  -v /usr/local/apache-maven-3.8.6/: /usr/local/apache-maven-3.8.6/
  -v /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7
  -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai \
  --restart "always" \
  --user root \
  --privileged=true \
  -d jenkins/jenkins:lts
```

:::info
**参数说明：**  
`-v /mydata/jenkins/:/var/jenkins_home` 挂载宿主主机目录到容器目录  
`-v /var/run/docker.sock:/var/run/docker.sock` 挂载docker的实例  
`-v /usr/local/apache-maven-3.8.6/: /usr/local/apache-maven-3.8.6/` 挂载宿主主机的maven  
`-v /mydata/maven/repository:/mydata/maven/repository` 挂载maven仓库目录  
`-v /etc/localtime:/etc/localtime` 同步时间  
`-e JAVA_OPTS=-Duser.timezone=Asia/Shanghai` 设置环境变量  
`--restart "always" ` 随着容器启动而启动  
`--user root` root用户执行命令  
`--privileged=true` 授予root权限  
`-d jenkins/jenkins:lts` 后台运行镜像

:::

#### jenkins自动安装maven、java环境，启动容器配置参数
```shell
docker run -p 8080:8080  \
  -v /mydata/jenkins/:/var/jenkins_home \
  -v /mydata/jenkins/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.8.6/repository:/root/.m2/repository
  -v /etc/localtime:/etc/localtime \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  -v /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7
  -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai \
  --restart "always" \
  --user root \
  --privileged=true \
  -d jenkins/jenkins:lts
```

### 6、进阶使用
[Docker Jenkins进阶配置](../advanced/docker-jenkins-advanced.md)

