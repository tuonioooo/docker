# Docker 备份MySQL数据库完整指南

## 目录
- [概述](#概述)
- [备份与还原基础](#备份与还原基础)
- [三种备份实现方法](#三种备份实现方法)
  - [方法一：Shell脚本备份](#方法一shell脚本备份)
  - [方法二：Java代码备份](#方法二java代码备份)
  - [方法三：批处理备份](#方法三批处理备份)
- [Docker容器MySQL备份](#docker容器mysql备份)
- [定时任务设置](#定时任务设置)
- [远程备份传输](#远程备份传输)
- [最佳实践](#最佳实践)
- [常见问题与解决方案](#常见问题与解决方案)

## 概述

本文档详细介绍MySQL数据库的备份及还原方法，包括Shell脚本、Java代码及批处理三种方式，特别针对Docker环境下的MySQL备份进行了详细说明，并提供了完整的定时任务配置。

## 备份与还原基础

### 核心命令

**备份命令:**
```bash
mysqldump -h127.0.0.1 -P3306 -utest -p123456 student > backup_file.sql
```

**还原命令:**
```bash
mysql -h127.0.0.1 -P3306 -utest -p123456 student < backup_file.sql
```

### 重要注意事项

1. **权限要求**: 使用备份命令需要开启相关数据库权限
2. **文件存在性**: 确保要还原的SQL文件存在
3. **数据库存在性**: 还原前需要保证目标数据库已存在
4. **用户权限**: 建议使用root用户或具备足够权限的用户

## 三种备份实现方法

### 方法一：Shell脚本备份

#### 1. 基础Shell脚本（非Docker环境）

```bash
#!/bin/bash
dateBackup=$(date +%Y-%m-%d_%H:%M:%S)
dir="/root/backupDB/sql/${dateBackup}"

# 创建备份目录
if [ ! -d "${dir}" ]; then
    mkdir ${dir}
    echo "创建文件夹成功"
else
    echo "文件夹已经存在"
fi

# 需要备份的数据库名
dbNames=(mybatis mybatis-plus)
for dbName in ${dbNames[@]}; do
    echo "-----------------> 备份 ${dbName} 数据库 <-----------------" >> /root/backupDB/log/${dateBackup}.log
    # 备份MySQL，1>>为正常输出，2>>为错误或警告输出到日志文件
    mysqldump -utest -p123456 ${dbName} 1>> ${dir}/${dbName}.sql 2>> /root/backupDB/log/${dateBackup}.log
    # 压缩文件（解压：gzip -d mybatis.sql.gz）
    gzip ${dir}/${dbName}.sql
done

# 清理过期备份
echo -e "\n----------------> 删除过期文件 <---------------------------" >> /root/backupDB/log/${dateBackup}.log
dirCount=`ls -l /root/backupDB/sql/|grep "^d"|wc -l`
if [ ${dirCount} -gt 7 ]; then
    # 删除超过七天的SQL备份
    find /root/backupDB/sql -mtime +6 -name "*_*" -exec rm -rf {} \;
    # 删除超过七天的日志
    find /root/backupDB/log -mtime +6 -name "*.log" -exec rm -rf {} \;
    echo -e "删除过期文件成功" >> /root/backupDB/log/${dateBackup}.log
else
    echo "删除过期文件失败，文件数量小于7" >> /root/backupDB/log/${dateBackup}.log
fi
```

#### 2. Docker容器MySQL备份脚本

```bash
#!/bin/bash
dateBackup=$(date +%Y-%m-%d_%H:%M:%S)
dir=/opt/docker/mysql/backup/${dateBackup}

# 在宿主机新建目录，通过挂载会自动添加到容器
if [ ! -d "${dir}" ]; then
    mkdir ${dir}
    echo "创建文件夹 ${dir} 成功" >> ${dir}/error.log
else
    echo "创建文件夹 ${dir} 失败，文件夹已存在" >> ${dir}/error.log
fi

# 需要备份的数据库名
dbNames=(student teacher car dog cat)
for dbName in ${dbNames[@]}; do
    echo "-----------------> 备份 ${dbName} 数据库 <-----------------" >> ${dir}/error.log
    # Docker容器内执行备份命令
    docker exec -i 642c89599d9b sh -c "mysqldump -ubackup -pAdmin@123 -h127.0.0.1 -P32773 ${dbName} 1>> /opt/backup/${dateBackup}/${dbName}.sql 2>> /opt/backup/${dateBackup}/error.log"
    # 在宿主机压缩备份文件
    gzip ${dir}/${dbName}.sql
done

# 清理过期备份文件
echo -e "\n----------------> 删除过期文件 <---------------------------" >> ${dir}/error.log
dirCount=`ls -l /opt/docker/mysql/backup/|grep "^d"|wc -l`
if [ ${dirCount} -gt 7 ]; then
    find /opt/docker/mysql/backup/ -mtime +6 -name "*_*" -exec rm -rf {} \;
    echo -e "删除过期文件成功" >> ${dir}/error.log
else 
    echo "删除过期文件失败，文件数量小于7" >> ${dir}/error.log
fi
```

#### 3. Docker容器备份配置

**启动容器时添加备份目录挂载:**
```bash
docker run -d \
  --name mysql_container \
  -v /opt/docker/mysql/backup:/opt/backup \
  -e MYSQL_ROOT_PASSWORD=123456 \
  mysql:8.0
```

**执行脚本权限设置:**
```bash
# 方法1：添加执行权限
chmod 777 backup.sh
./backup.sh

# 方法2：直接使用sh执行
sh ./backup.sh
```

### 方法二：Java代码备份

```java
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MySQLBackup {
    public static void main(String[] args) throws Exception {
        // 备份示例
        dbBackUp("127.0.0.1", "root", "123456", "3306", 
                "mybatis,mybatis-plus", "D:\\backup\\");
        
        // 还原示例（注释掉，按需使用）
        // reduction("127.0.0.1", "3306", "root", "123456", 
        //          "mybatis-plus", "2021-07-27_14-19-04/mybatis-plus.sql");
    }

    /**
     * 数据库备份方法
     * @param host 主机地址
     * @param userName 用户名
     * @param password 密码
     * @param port 端口
     * @param dbNames 数据库名（多个用逗号分隔）
     * @param backupPath 备份路径
     */
    public static void dbBackUp(String host, String userName, String password, 
                               String port, String dbNames, String backupPath) {
        String format = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss").format(new Date());
        File backupDir = new File(backupPath + format);
        
        if (!backupDir.mkdir()) {
            System.out.println("创建备份目录失败");
            return;
        }
        
        String[] dbNameArray = dbNames.split(",");
        for (String dbName : dbNameArray) {
            String pathSql = backupPath + format + "\\" + dbName + ".sql";
            String cmd = "cmd /c mysqldump" + " -h" + host + " -P" + port + 
                        " -u" + userName + " -p" + password + " " + dbName + " > " + pathSql;
            
            System.out.println("执行命令：" + cmd);
            
            try {
                Process process = Runtime.getRuntime().exec(cmd);
                if (process.waitFor() == 0) {
                    System.out.println(dbName + " 数据库备份成功!");
                } else {
                    System.out.println(dbName + " 数据库备份失败!");
                }
            } catch (IOException | InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 数据库还原方法
     * @param host 主机地址
     * @param port 端口
     * @param userName 用户名
     * @param password 密码
     * @param databaseName 数据库名
     * @param fileName 备份文件路径
     */
    public static void reduction(String host, String port, String userName, 
                               String password, String databaseName, String fileName) throws Exception {
        File datafile = new File(fileName);
        if (!datafile.exists()) {
            System.out.println(fileName + " 文件不存在，请检查");
            return;
        }
        
        String cmd = "cmd /c mysql -h" + host + " -P" + port + " -u" + userName + 
                    " -p" + password + " " + databaseName + " < " + datafile;
        
        System.out.println("还原命令：" + cmd);
        
        Process exec = Runtime.getRuntime().exec(cmd);
        if (exec.waitFor() == 0) {
            System.out.println(databaseName + " 数据库还原成功，还原文件：" + datafile);
        } else {
            System.out.println("数据库还原失败");
        }
    }
}
```

### 方法三：批处理备份

**Windows批处理脚本示例:**
```batch
@echo off
set dateBackup=%date:~0,4%-%date:~5,2%-%date:~8,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
set backupDir=D:\backup\mysql\%dateBackup%

if not exist "%backupDir%" (
    mkdir "%backupDir%"
    echo 创建备份目录成功
) else (
    echo 备份目录已存在
)

rem 备份数据库列表
set dbList=mybatis mybatis-plus student

for %%d in (%dbList%) do (
    echo 正在备份数据库: %%d
    mysqldump -h127.0.0.1 -P3306 -uroot -p123456 %%d > "%backupDir%\%%d.sql"
    if %ERRORLEVEL%==0 (
        echo %%d 备份成功
    ) else (
        echo %%d 备份失败
    )
)

echo 备份完成
pause
```

## Docker容器MySQL备份

### 方法1：直接执行容器内命令

```bash
# 备份单个数据库
docker exec -i mysql_container mysqldump -uroot -p123456 testdb > testdb_backup.sql

# 备份所有数据库
docker exec -i mysql_container mysqldump -uroot -p123456 --all-databases > all_databases_backup.sql
```

### 方法2：通过容器网络备份

```bash
# 使用临时容器进行备份
docker run --rm \
  --network container:mysql_container \
  -v $(pwd):/backup \
  mysql:8.0 \
  mysqldump -h127.0.0.1 -uroot -p123456 --all-databases > /backup/mysql_backup.sql
```

### 方法3：数据卷备份

```bash
# 备份数据卷
docker run --rm \
  --volumes-from mysql_container \
  -v $(pwd):/backup \
  ubuntu \
  tar czf /backup/mysql_volume_backup.tar.gz /var/lib/mysql/
```

## 定时任务设置

### Crontab配置

```bash
# 编辑定时任务
crontab -e

# 每天凌晨1点执行备份脚本
0 1 * * * /root/backupDB/backup.sh

# 查看定时任务
crontab -l

# 查看定时任务日志
tail -f /var/log/cron
```

### 环境变量问题解决

**在Shell脚本中添加环境变量:**
```bash
#!/bin/bash
# 用户环境变量
source ~/.bashrc
# 系统环境变量
source /etc/profile
```

**在Crontab中添加环境变量:**
```bash
# 用户环境变量
0 1 * * * . ~/.bashrc;/root/backupDB/backup.sh

# 系统环境变量
0 1 * * * . /etc/profile;/root/backupDB/backup.sh
```

### Cron服务管理

```bash
# 启动Cron服务
systemctl start crond

# 停止Cron服务
systemctl stop crond

# 重启Cron服务
systemctl restart crond

# 查看Cron服务状态
systemctl status crond
```

### Crontab重要注意事项

1. **执行延迟**: 新创建的cron job不会马上执行，至少要过2分钟
2. **输出处理**: 每条JOB执行后系统会发送邮件，建议重定向输出：`> /dev/null 2>&1`
3. **服务重启**: 当crontab突然失效时，尝试重启crond服务
4. **删除警告**: 千万别乱运行`crontab -r`，会删除用户的所有crontab
5. **特殊字符**: 在crontab中`%`有特殊含义，使用时需要转义：`\%`

### 输出重定向详解

```bash
# 标准输出重定向到空设备
command > /dev/null

# 错误输出重定向到标准输出
command 2>&1

# 所有输出都重定向到空设备
command > /dev/null 2>&1
```

其中：
- `1`表示stdout标准输出
- `2`表示stderr标准错误
- `&`表示等同于
- `/dev/null`代表空设备文件

## 远程备份传输

### SCP传输配置

使用SCP将Docker容器中的备份文件传输到远程服务器：

```bash
# 传输单个备份文件
scp /opt/docker/mysql/backup/2021-07-27_14-19-14/student.sql.gz \
    user@remote-server:/backup/mysql/

# 传输整个备份目录
scp -r /opt/docker/mysql/backup/2021-07-27_14-19-14/ \
    user@remote-server:/backup/mysql/

# 在备份脚本中集成SCP传输
for dbName in ${dbNames[@]}; do
    # 备份数据库
    docker exec -i mysql_container mysqldump -uroot -p123456 ${dbName} > ${dir}/${dbName}.sql
    gzip ${dir}/${dbName}.sql
    
    # 传输到远程服务器
    scp ${dir}/${dbName}.sql.gz user@remote-server:/backup/mysql/
    if [ $? -eq 0 ]; then
        echo "${dbName} 备份文件传输成功"
    else
        echo "${dbName} 备份文件传输失败"
    fi
done
```

### 免密传输配置

```bash
# 生成SSH密钥对
ssh-keygen -t rsa

# 将公钥复制到远程服务器
ssh-copy-id user@remote-server

# 测试免密登录
ssh user@remote-server
```

## 最佳实践

### 1. 备份策略设计

- **频率设置**: 根据数据重要性设定备份频率（每日/每周）
- **保留策略**: 设置合理的备份保留天数（如7天）
- **多地备份**: 将备份文件存储在不同服务器或云存储
- **压缩存储**: 使用gzip压缩备份文件节省存储空间

### 2. 安全考虑

```bash
# 使用环境变量存储密码
export MYSQL_PASSWORD="your_password"
mysqldump -uroot -p$MYSQL_PASSWORD testdb > backup.sql

# 设置备份文件权限
chmod 600 backup.sql

# 创建专用备份用户
CREATE USER 'backup_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT, LOCK TABLES, SHOW VIEW ON *.* TO 'backup_user'@'localhost';
```

### 3. 监控和日志

```bash
# 备份脚本中添加监控
BACKUP_SIZE=$(stat -c%s backup.sql)
if [ $BACKUP_SIZE -lt 1000000 ]; then
    echo "警告: 备份文件异常小" | mail -s "备份警告" admin@example.com
fi

# 记录备份耗时
START_TIME=$(date +%s)
# ... 备份操作 ...
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
echo "备份耗时: ${DURATION}秒" >> /var/log/mysql_backup.log
```

### 4. 性能优化

```bash
# 使用单事务保证一致性
mysqldump --single-transaction --routines --triggers testdb > backup.sql

# 并行备份多个数据库
for dbName in ${dbNames[@]}; do
    {
        mysqldump -uroot -p$MYSQL_PASSWORD ${dbName} > ${dbName}_backup.sql
        gzip ${dbName}_backup.sql
    } &
done
wait  # 等待所有后台任务完成
```

## 常见问题与解决方案

### Q1: Docker容器备份时提示找不到mysqldump命令

**解决方案:**
```bash
# 确保在正确的容器中执行命令
docker exec -it mysql_container which mysqldump

# 如果容器中没有mysqldump，使用MySQL客户端容器
docker run --rm --link mysql_container:mysql mysql:8.0 \
  mysqldump -hmysql -uroot -p123456 testdb > backup.sql
```

### Q2: 定时任务无法执行，提示命令找不到

**解决方案:**
```bash
# 在脚本开头添加环境变量
#!/bin/bash
source /etc/profile
source ~/.bashrc
export PATH=/usr/local/bin:/usr/bin:/bin

# 或使用完整路径
/usr/bin/docker exec -i mysql_container /usr/bin/mysqldump -uroot -p123456 testdb
```

### Q3: 大数据库备份超时

**解决方案:**
```bash
# 增加超时设置
mysqldump --single-transaction --lock-tables=false --routines \
  --set-gtid-purged=OFF --default-character-set=utf8mb4 \
  -uroot -p123456 large_db > backup.sql

# 使用mydumper进行并行备份
docker run --rm --link mysql_container:mysql \
  -v $(pwd):/backup \
  mydumper_image \
  mydumper -h mysql -u root -p 123456 -c -B large_db -o /backup/
```

### Q4: 备份文件权限问题

**解决方案:**
```bash
# 设置正确的文件权限
umask 077  # 设置默认权限为600
mysqldump -uroot -p123456 testdb > backup.sql

# 修改已存在文件的权限
chmod 600 backup.sql
chown mysql:mysql backup.sql
```

### Q5: 跨版本恢复兼容性问题

**解决方案:**
```bash
# 备份时指定兼容模式
mysqldump --compatible=mysql323 --skip-opt --create-options \
  -uroot -p123456 testdb > backup.sql

# 还原前检查版本兼容性
mysql --version
```

## 总结

Docker环境下的MySQL备份需要综合考虑多个因素：

1. **选择合适的备份方法**: Shell脚本适合Linux环境，Java代码适合跨平台，批处理适合Windows
2. **配置可靠的定时任务**: 注意环境变量和权限问题
3. **实施多重备份策略**: 本地备份+远程传输+云存储
4. **建立监控和告警机制**: 及时发现备份异常
5. **定期测试恢复流程**: 确保备份文件的可用性

通过本文档提供的完整方案，可以建立起稳定可靠的Docker MySQL备份体系，确保数据安全。