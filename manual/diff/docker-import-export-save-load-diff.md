# Docker import、export 与 save、load 命令 区别

[Docker命令大全](../docker-command-manual.md)

| **对比项** | **docker export/import** | **docker save/load** |
| --- | --- | --- |
| **文件大小** | 导出的文件较小 | 保存的文件较大 |
| **是否可重命名镜像** | 支持：`docker import`<br/> 时可指定新镜像名称 | 不支持直接重命名镜像 |
| **是否支持多镜像打包** | 不支持 | 支持 |
| **是否包含镜像历史** | 不包含：只保留容器快照状态，无历史记录和元数据信息 | 包含：保留所有历史记录和元数据信息 |
| **是否支持镜像回滚** | 不支持 | 支持 |
| **主要应用场景** | 制作基础镜像，分发轻量级环境 | 部署离线环境，分发多个镜像的整体解决方案 |


### **总结**
+ `**docker export/import**`：
    - 适合于快速导出容器当前状态用于分发或简单备份。
    - 不适用于需要保留完整镜像历史或进行版本控制的场景。
+ `**docker save/load**`：
    - 更适合复杂应用部署，比如离线分发完整的镜像组合。
    - 保留完整历史记录，便于回滚和复用。

**注意**：两种方法不可混用，例如：用 `docker export` 导出的文件无法用 `docker load` 加载。


