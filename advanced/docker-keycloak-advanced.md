# Keycloak Docker容器部署文档

## 概述

本文档描述了如何使用Docker Compose部署Keycloak身份认证和访问管理系统。该部署方案包含MySQL数据库和Keycloak服务两个容器，通过Docker网络进行通信。


## 部署

* [开发环境部署](./docker-keycloak-dev.md)
* [生产环境部署](./docker-keycloak-prod.md)


## 参考资料

- [Keycloak官方文档](https://www.keycloak.org/documentation)
  - [Keycloak官方相关配置文档汇总](https://www.keycloak.org/server/all-config)
  - [Keycloak官方Docker部署文档](https://www.keycloak.org/getting-started/getting-started-docker)
  - [Keycloak容器运行文档](https://www.keycloak.org/server/containers)
    - 如何自定义构建镜像
    - 基础镜像参数配置，比如：KC_DB、KC_DB_URL、KC_DB_USERNAME
  - [Keycloak配置TLS(如: https)协议](https://www.keycloak.org/server/enabletls)
  - [Keycloak配置数据库](https://www.keycloak.org/server/db)
    - 支持mariadb、mssql、mysql、oracle、postgres
    - 默认情况下，服务器使用 dev-file 数据库。这是服务器用于持久化数据的默认数据库，仅用于开发用例。dev dev-file 数据库不适用于生产用例，必须在部署到生产环境之前进行替换。
- [Keycloak镜像推荐](./docker-keycloak-image.md)
- [MySQL官方文档](https://dev.mysql.com/doc/)
- [Docker Compose文档](https://docs.docker.com/compose/)