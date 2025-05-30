# Docker inspect 命令

[Docker命令大全](./docker-command-manual.md)

`docker inspect` 

命令用于获取 Docker 对象（容器、镜像、卷、网络等）的详细信息，同时返回 JSON 格式的详细信息，可以帮助用户了解对象的配置和状态。

### 语法
docker inspect [OPTIONS] NAME|ID [NAME|ID...]

OPTIONS 说明：

+ `**-f, --format**`: 使用 Go 模板语法格式化输出。
+ `**--type**`: 返回指定类型的对象信息（可选类型：`container`、`image`、`network`、`volume`）。

### 实例
**1、检查容器**

```shell
docker inspect my_container
```

返回 my_container 容器的详细信息。

**2、检查镜像**

```shell
docker inspect my_image
```

返回 my_image 镜像的详细信息。

**3、检查卷**

```shell
docker inspect my_volume
```

返回 my_volume 卷的详细信息。

**4、检查网络**

```shell
docker inspect my_network
```

返回 my_network 网络的详细信息。

**5、格式化输出**

```shell
docker inspect --format '{{ .State.Running }}' my_container
```

返回 my_container 容器的运行状态，格式化输出为布尔值。

**6、检查多个对象**

```shell
docker inspect my_container my_image
```

返回 my_container 容器和 my_image 镜像的详细信息。

### 实例输出
容器信息：

docker inspect my_container

输出：

```shell
[
    {
        "Id": "d2f5e3f19a6a",
        "Created": "2024-07-23T00:00:00Z",
        "Path": "bash",
        "Args": [],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 12345,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2024-07-23T00:00:00Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:abc123",
        "ResolvConfPath": "/var/lib/docker/containers/d2f5e3f19a6a/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/d2f5e3f19a6a/hostname",
        "HostsPath": "/var/lib/docker/containers/d2f5e3f19a6a/hosts",
        "LogPath": "/var/lib/docker/containers/d2f5e3f19a6a/d2f5e3f19a6a-json.log",
        "Name": "/my_container",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": null,
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": null,
            "DiskQuota": 0,
            "KernelMemory": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "Mounts": [],
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/l/abc123/diff",
                "MergedDir": "/var/lib/docker/overlay2/merged",
                "UpperDir": "/var/lib/docker/overlay2/upper",
                "WorkDir": "/var/lib/docker/overlay2/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "d2f5e3f19a6a",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {},
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "bash"
            ],
            "Image": "ubuntu",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {}
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "abc123",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "/var/run/docker/netns/abc123",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "abc123",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "abc123",
                    "EndpointID": "abc123",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
```

### 使用场景
+ **调试容器**: 获取容器的详细配置信息，以便进行调试和排查问题。
+ **查看网络配置**: 查看容器的网络配置信息，了解其网络连接状态。
+ **监控资源**: 获取容器的资源配置信息和使用情况，便于进行资源管理和监控。
+ **脚本自动化**: 在自动化脚本中使用 `docker inspect` 获取对象的详细信息，以进行后续操作。

### 高级使用示例

* [Docker inspect 查看容器、镜像的高级用法](../advanced/docker-inspect-advanced.md)

`docker inspect` 命令是 Docker 中非常强大和实用的命令之一，允许用户获取容器、镜像、卷、网络等对象的详细信息。通过使用该命令，用户可以深入了解和管理 Docker 对象的配置和状态，满足各种调试、监控和管理需求。

