# Docker Hub账号服务说明

在 **Docker Hub** 上发布和共享镜像时，是否收费取决于您使用的账户类型和镜像的存储方式。

### 1. **Docker Hub 免费账户**
对于 **免费用户**，Docker Hub 提供了以下免费使用的服务：

- **公共镜像**：您可以免费发布公共镜像，这些镜像对所有用户开放，可以被任何人拉取和使用。
- **私有镜像**：免费账户可以拥有 **最多 1 个私有镜像仓库**，而且每月有 **1000 次拉取限制**（对于公共镜像不限制）。如果需要更多的私有镜像仓库，或者更高的拉取限制，则需要升级到付费账户。

### 2. **Docker Hub 付费账户**
Docker Hub 提供了 **Pro**、**Team** 和 **Enterprise** 等付费套餐，主要区别在于以下几个方面：

- **Pro**：提供 **无限私有仓库**，更高的并发拉取次数（每月 5000 次），并增加了对镜像存储的管理功能。
- **Team**：适合团队协作，提供更多的私有仓库和更高的拉取配额。
- **Enterprise**：面向大企业，提供更强的支持和服务。

### 3. **拉取次数限制**
无论是公共镜像还是私有镜像，Docker Hub 目前对匿名用户和免费账户的拉取次数都有限制。具体来说：

- **匿名用户**（未登录）每小时只能拉取 **100 次**镜像。
- **免费用户**每小时可以拉取 **200 次**镜像。
- 付费用户可以享受更高的拉取配额。

### 4. **共享镜像是否收费**
如果您发布的是 **公共镜像**，**共享镜像本身是免费的**。但是，如果镜像是私有的，则需要付费账户来管理私有镜像。

### 5. **官方的定价说明**

[定价页面](https://www.docker.com/pricing)。


### 总结
- 发布和共享 **公共镜像** 在 Docker Hub 上是免费的。
- **私有镜像**的存储会有一些限制，免费账户只能拥有 1 个私有仓库，如果需要更多私有仓库，或者更高的拉取限制，则需要购买 **付费账户**。

