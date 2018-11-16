# docker应用：SpringBoot搭建app自定义镜像部署到Docker中

**一.idea搭建SpringBoot基础项目Springboot-docker**

目录如下：

![](/assets/docker-001.png)

**二.添加POM依赖**

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.master</groupId>
    <artifactId>springboot-docker</artifactId>
    <version>1.0</version>
    <packaging>jar</packaging>

    <name>springboot-docker</name>
    <description>SpringBoot基于Docker的应用</description>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.0.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
        <docker.image.prefix>springio</docker.image.prefix>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>

    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
            <plugin>
                <groupId>com.spotify</groupId>
                <artifactId>docker-maven-plugin</artifactId>
                <version>0.4.13</version>
                <configuration>
                    <imageName>${docker.image.prefix}/${project.artifactId}</imageName> <!--镜像名称-->
                    <baseImage>openjdk:8-jdk-alpine</baseImage><!--镜像文件-->
                    <dockerHost>http://docker.cn:2375</dockerHost><!--docker 服务器ip 地址-->
                    <entryPoint>["java", "-jar", "/${project.build.finalName}.jar"]</entryPoint>
                    <resources>
                        <resource>
                            <targetPath>/</targetPath>
                            <directory>${project.build.directory}</directory>
                            <include>${project.build.finalName}.jar</include>
                        </resource>
                    </resources>
                </configuration>
            </plugin>
        </plugins>
    </build>


</project>
```

**三.执行maven的命令**

![](/assets/docker-002.png)

**四.输出如下：**

```
D:\Java\jdk1.8.0_92\bin\java -Dmaven.multiModuleProjectDirectory=E:\Github\Springboot-master\springboot-docker "-Dmaven.home=D:\Tools\IntelliJ IDEA 2017.3.1\plugins\maven\lib\maven3" "-Dclassworlds.conf=D:\Tools\IntelliJ IDEA 2017.3.1\plugins\maven\lib\maven3\bin\m2.conf" "-javaagent:D:\Tools\IntelliJ IDEA 2017.3.1\lib\idea_rt.jar=25923:D:\Tools\IntelliJ IDEA 2017.3.1\bin" -Dfile.encoding=UTF-8 -classpath "D:\Tools\IntelliJ IDEA 2017.3.1\plugins\maven\lib\maven3\boot\plexus-classworlds-2.5.2.jar" org.codehaus.classworlds.Launcher -Didea.version=2017.3.5 -s E:\.m2\settings.xml clean package docker:build -DskipTests
[WARNING] 
[WARNING] Some problems were encountered while building the effective settings
[WARNING] 'profiles.profile.id' must be unique but found duplicate profile with id jdk-1.8 @ E:\.m2\settings.xml
[WARNING] 
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building springboot-docker 1.0
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-clean-plugin:3.1.0:clean (default-clean) @ springboot-docker ---
[INFO] Deleting E:\Github\Springboot-master\springboot-docker\target
[INFO] 
[INFO] --- maven-resources-plugin:3.1.0:resources (default-resources) @ springboot-docker ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO] Copying 0 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.0:compile (default-compile) @ springboot-docker ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to E:\Github\Springboot-master\springboot-docker\target\classes
[INFO] 
[INFO] --- maven-resources-plugin:3.1.0:testResources (default-testResources) @ springboot-docker ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory E:\Github\Springboot-master\springboot-docker\src\test\resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.0:testCompile (default-testCompile) @ springboot-docker ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to E:\Github\Springboot-master\springboot-docker\target\test-classes
[INFO] 
[INFO] --- maven-surefire-plugin:2.22.1:test (default-test) @ springboot-docker ---
[INFO] Tests are skipped.
[INFO] 
[INFO] --- maven-jar-plugin:3.1.0:jar (default-jar) @ springboot-docker ---
[INFO] Building jar: E:\Github\Springboot-master\springboot-docker\target\springboot-docker-1.0.jar
[INFO] 
[INFO] --- spring-boot-maven-plugin:2.1.0.RELEASE:repackage (repackage) @ springboot-docker ---
[INFO] Replacing main artifact E:\Github\Springboot-master\springboot-docker\target\springboot-docker-1.0.jar
[INFO] 
[INFO] --- docker-maven-plugin:0.4.13:build (default-cli) @ springboot-docker ---
[INFO] Copying E:\Github\Springboot-master\springboot-docker\target\springboot-docker-1.0.jar -> E:\Github\Springboot-master\springboot-docker\target\docker\springboot-docker-1.0.jar
[INFO] Building image springio/springboot-docker
Step 1/3 : FROM openjdk:8-jdk-alpine
Trying to pull repository docker.io/library/openjdk ... 
Pulling from docker.io/library/openjdk
4fe2ade4980c: Pulling fs layer 
6fc58a8d4ae4: Pulling fs layer 
ef87ded15917: Pulling fs layer 
6fc58a8d4ae4: Downloading [==================================================>]    238 B/238 B
6fc58a8d4ae4: Verifying Checksum 
6fc58a8d4ae4: Download complete 
.......
ef87ded15917: Extracting [============================================>      ] 62.95 MB/70.61 MB
ef87ded15917: Extracting [==============================================>    ] 65.73 MB/70.61 MB
ef87ded15917: Extracting [================================================>  ] 67.96 MB/70.61 MB
ef87ded15917: Extracting [=================================================> ] 69.63 MB/70.61 MB
ef87ded15917: Extracting [==================================================>] 70.61 MB/70.61 MB
ef87ded15917: Pull complete 
Digest: sha256:b18e45570b6f59bf80c15c78d7f0daff1e18e9c19069c323613297057095fda6
Status: Downloaded newer image for docker.io/openjdk:8-jdk-alpine
 ---> 97bc1352afde
Step 2/3 : ADD /springboot-docker-1.0.jar //
 ---> 84cbd9dbcd7f
Removing intermediate container d72239b91d81
Step 3/3 : ENTRYPOINT java -jar /springboot-docker-1.0.jar
 ---> Running in 2958ec02daaa
 ---> deea69ed0227
Removing intermediate container 2958ec02daaa
Successfully built deea69ed0227
[INFO] Built springio/springboot-docker
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 06:59 min
[INFO] Finished at: 2018-11-16T16:48:35+08:00
[INFO] Final Memory: 48M/308M
[INFO] ------------------------------------------------------------------------

Process finished with exit code 0
```

上面就会把相应的jar打成镜像，添加到远程服务端docker上

**五.在docker服务器上运行相应的命令：**

```
[root@localhost ~]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
[root@localhost ~]# docker image ls
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
springio/springboot-docker   latest              deea69ed0227        9 minutes ago       121 MB
docker.io/openjdk            8-jdk-alpine        97bc1352afde        3 weeks ago         103 MB
[root@localhost ~]# docker run -d -p 16000:8080 springio/springboot-docker
58766045c234c262e9049d4ab2dea1542e02bbeec55f2e1c083aabc2f5b8f319
```

访问http://docker.cn:16000/  即可看到如下效果：

![](/assets/docker-003.png)

