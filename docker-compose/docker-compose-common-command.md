# docker-compose 常用命令

#### help

`docker-compose -help` 查看帮助。

#### config

`docker-compose config -q` 验证docker-compose.yml文件。当配置正确时，不输出任何内容，当配置错误时，输出错误信息。

#### pull

`docker-compose pull` 拉取服务依赖的镜像。

```docker
# 拉取工程中所有服务依赖的镜像
docker-compose pull
# 拉取工程中 nginx 服务依赖的镜像
docker-compose pull nginx
# 拉取镜像过程中不打印拉取进度信息
docker-compose pull -q
```

#### up

`docker-compose up` 创建并启动所有服务的容器。指定多个yml加-f选项。以守护进程模式运行加-d选项。

```docker
# 前台启动
docker-compose up
# 后台启动
docker-compose up -d
# -f 指定使用的 Compose 模板文件，默认为 docker-compose.yml，可以多次指定，指定多个 yml
docker-compose -f docker-compose.yml up -d
```

#### logs

`docker-compose logs` 查看服务容器的输出日志。默认情况下，`docker-compose` 将对不同的服务输出使用不同的颜色来区分。可以通过 `--no-color` 来关闭颜色。

```docker
# 输出日志，不同的服务输出使用不同的颜色来区分
docker-compose logs
# 跟踪日志输出
docker-compose logs -f
# 关闭颜色
docker-compose logs --no-color
```

#### ps

`docker-compose ps` 列出工程中所有服务的容器。

```docker
# 列出工程中所有服务的容器
docker-compose ps
# 列出工程中指定服务的容器
docker-compose ps nginx
```

#### run

`docker-compose run` 在指定服务容器上额外执行一个命令。

```docker
# 在工程中指定服务的容器上执行 echo "helloworld"
docker-compose run nginx echo "helloworld"
```

#### exec

`docker-compose exec` 进入服务容器。

```docker
# 进入工程中指定服务的容器
docker-compose exec nginx bash
# 当一个服务拥有多个容器时，可通过 --index 参数进入到该服务下的任何容器
docker-compose exec --index=1 nginx bash
```

#### pause

`docker-compose pause` 暂停服务容器

```docker
# 暂停工程中所有服务的容器
docker-compose pause
# 暂停工程中指定服务的容器
docker-compose pause nginx
```

#### unpause

`docker-compose unpause` 恢复服务容器。

```docker
# 恢复工程中所有服务的容器
docker-compose unpause
# 恢复工程中指定服务的容器
docker-compose unpause nginx
```

#### restart

`docker-compose restart` 重启服务容器。

```docker
# 重启工程中所有服务的容器
docker-compose restart
# 重启工程中指定服务的容器
docker-compose restart nginx
```

#### start

`docker-compose start` 启动服务容器。

```docker
# 启动工程中所有服务的容器
docker-compose start
# 启动工程中指定服务的容器
docker-compose start nginx
```

#### stop

`docker-compose stop` 停止服务容器。

```docker
# 停止工程中所有服务的容器
docker-compose stop
# 停止工程中指定服务的容器
docker-compose stop nginx
```

#### kill

`docker-compose kill` 通过发送SIGKILL信号停止指定服务的容器。

```docker
# 通过发送 SIGKILL 信号停止工程中指定服务的容器
docker-compose kill nginx
```

#### rm

`docker-compose rm`  删除服务（停止状态）容器。

```docker
# 删除所有（停止状态）服务的容器
docker-compose rm
# 先停止所有服务的容器，再删除所有服务的容器
docker-compose rm -s
# 不询问是否删除，直接删除
docker-compose rm -f
# 删除服务容器挂载的数据卷
docker-compose rm -v
# 删除工程中指定服务的容器
docker-compose rm -sv nginx
```

#### down

`docker-compose down ` 停止并删除所有服务的容器、网络、镜像、数据卷。

```docker
# 停止并删除工程中所有服务的容器、网络
docker-compose stop
# 停止并删除工程中所有服务的容器、网络、镜像
docker-compose down --rmi all
# 停止并删除工程中所有服务的容器、网络、数据卷
docker-compose down -v
```

#### images

`docker-compose images` 打印服务容器所对应的镜像。

```docker
# 打印所有服务的容器所对应的镜像
docker-compose images
# 打印指定服务的容器所对应的镜像
docker-compose images nginx
```

#### port

`docker-compose port` 打印指定服务容器的某个端口所映射的宿主机端口。

```docker
docker-compose port nginx 80
0.0.0.0:80
docker-compose port jenkins 8080
0.0.0.0:8088
```

#### top

`docker-compose top` 显示正在运行的进程。

```docker
# 显示工程中所有服务的容器正在运行的进程
docker-compose top
# 显示工程中指定服务的容器正在运行的进程
docker-compose top nginx
```

其他命令 可以参考官方文档 ，日后用到时在补充维护
