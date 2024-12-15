# docker空(none)镜像处理


### 有用镜像

通过docker images -a 命令才会显示的none镜像，这些镜像是镜像分层的中间镜像，同时这些镜像不会造成空间损耗

### 无用镜像

通过docker images 命令显示的none镜像，这些镜像是由于新加镜像占用了原有镜像的标签，原有镜像就变成了none镜像。
这些none镜像有一个好听的名字：空悬镜像（dangling images）,同时docker并没有自动删除这些镜像的机制。
那么如何删除这些无用镜像呢？

### 删除无用镜像

```shell
docker rmi $(docker images -f "dangling=true" -q)
```


