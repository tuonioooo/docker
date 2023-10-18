
```cnf
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# 官网：配置文件命令索引目录 8.1是对应的版本号，切换不同版本号就可以找对应的命令索引目录
# https://dev.mysql.com/doc/refman/8.1/en/server-option-variable-reference.html

# Custom config should go here

# MySQL Server 配置参数
[mysqld]

# 设置端口号，默认为 3306
port = 3306

# 设置 MySQL 数据文件存储路径，默认值为mysqld安装目录 linux 通常为 `/var/lib/mysql` 
datadir = /var/lib/mysql

# 允许最大连接数 	默认值 Default Value=151, Minimum Value = 1, Maximum Value = 100000
max_connections=5000

# 服务器等待非交互式连接的时间 默认值 28800
# Default Value 默认值	28800
# Minimum Value 最小值	1
# Maximum Value (Windows) 最大值（视窗）	2147483
# Maximum Value (Other) 最大值（其他）	31536000
# Unit 单位	seconds 秒
wait_timeout=28800

# 客户端和服务器之间传输的最大数据包大小、默认为 64M, 最大值为1G
max_allowed_packet=64M

# 是否将表名视为大小写敏感  0：区分、1：不区分、2：表示表名根据操作系统的规则进行比较
# 默认值
# Default Value (macOS)	2
# Default Value (Unix)	0
# Default Value (Windows)	1
lower_case_table_names=1

# 服务器的字符集和排序规则 默认值 utf8mb4_0900_ai_ci
collation_server=utf8mb4_0900_ai_ci

# 服务器的字符集 默认值 utf8mb4
character_set_server=utf8mb4

# 是一个 MySQL 启动选项，它使得 MySQL 服务器在启动时跳过权限验证机制，允许所有用户以超级管理员的身份（root）登录，无需提供密码 默认值 OFF(关闭)、开启时放开注释即可
# 适用于Mysql直接安装、docker 安装Mysql 是有初始化密码设置的无需担心
# skip-grant-tables


# 用于禁用二进制日志记录（binary logging）功能。二进制日志记录是 MySQL 的一项重要功能，用于记录数据库中所做的更改操作，以便进行数据恢复、数据复制和高可用性配置等。
# 默认是开启的，命令如下 开启：log-bin = mysql-bin, 关闭： skip-log-bin/disable-log-bin
# 见官网 https://dev.mysql.com/doc/refman/8.1/en/replication-options-binary-log.html#sysvar_log_bin
# skip-log-bin

# 用于设置二进制日志文件(log-bin 备份产生的文件)过期的天数。当二进制日志文件的生成时间超过指定的天数时，MySQL 将自动清理（删除）旧的二进制日志文件，以释放磁盘空间。
# 默认值是 0天 一般配合log-bin使用
expire_logs_days = 2

# warning & error log
log-warnings = 1
log-error = /home/mysql/mysql/log/mysql.err

# 用于设置日志输出的方式，默认为FILE，你可以将它设为TABLE，然后就可以查询mysql架构下的slow_log表了
# 具体选项值如下：
# FILE：将日志输出到文件中。
# TABLE：将日志输出到系统日志表中（mysql.general_log 或 mysql.slow_log）。
# NONE：不输出日志。
log_output = FILE 


# 是否开启慢查询  默认是关闭的    值说明   1(or ON): 开启, 0(or OFF): 关闭
slow_query_log = 1
# 慢查询的日志文件 默认文件名：host_name-slow.log，注意：log_output = FILE 才会用到当前选项！
slow_query_log_file = /home/mysql/mysql/log/slow.log 

# 慢查询时间 超过1秒则为慢查询, 默认值 10
long-query-time = 5 

# 用于禁用 MySQL 主机名缓存功能。当你使用该选项启动 MySQL 服务器时，MySQL 将不会将主机名存储在缓存中
# 默认情况下，MySQL 会缓存主机名，这样可以提高连接性能，减少对 DNS 查询的依赖。但在某些情况下，你可能希望禁用主机名缓存，以实时地获取主机名的最新解析结果
# 要使用 skip-host-cache 参数，在 my.cnf 配置文件或启动命令中添加以下行：skip-host-cache 或通过在命令行启动 MySQL 服务器时指定该参数：mysqld --skip-host-cache
skip-host-cache

[mysql]
# 更多命令配置详见 https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html
# MySQL 支持以上选项，这些选项可以在命令行或选项文件的 [mysql] AND [client] 组中指定，只需去掉前面的 --  
# 设置mysql客户端默认字符集
default-character-set=utf8mb4
# 本地客户端登录mysql的用户名
user=root
# 防止本地客户端输入密码后出现警告[Warning] Using a password on the command line interface can be insecure.
password=yourpassword

[mysqldump]
# 更多命令配置详见 https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html
# MySQL 支持以上选项，这些选项可以在命令行或选项文件的 [mysql] AND [client] 组中指定，只需去掉前面的 --
# 设置mysql客户端默认字符集
default-character-set=utf8mb4

# 设置备份时mysql输入的密码，防止出现 [Warning] Using a password on the command line interface can be insecure
password=yourpassword

[client]
# 更多命令配置详见 https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html
# MySQL 支持以上选项，这些选项可以在命令行或选项文件的 [mysql] AND [client] 组中指定，只需去掉前面的 --
port=3306
default-character-set=utf8mb4
```
> 官网命令配置文档  
> [`mysqld`](https://dev.mysql.com/doc/refman/8.1/en/server-option-variable-reference.html)  
> [`mysql`](https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html)  
> [`mysqldump`](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)  
> [`client`](https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html)  
> 配置示例[my.cnf](./my.cnf.md)
> * 设置忽略表名大小写
> * 关闭了binlog日志
> * 设置了一些相关的字符集