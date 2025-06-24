
```yml
version: '3.8'

services:
  # MySQL 数据库
  mysql:
    container_name: keycloak-mysql
    image: mysql:8.4
    command: [
      "--character-set-server=utf8mb4",
      "--collation-server=utf8mb4_unicode_ci",
      "--lower-case-table-names=1",
      "--innodb-buffer-pool-size=512M",
      "--max-connections=200",
      "--slow-query-log=1",
      "--long-query-time=2"
    ]
    ports:
      - "127.0.0.1:3306:3306"  # 只绑定到本地接口
    volumes:
      - mysql_data:/var/lib/mysql
      - ./mysql/conf.d:/etc/mysql/conf.d:ro
      - ./mysql/logs:/var/log/mysql
      - ./backup:/backup:ro
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/mysql_root_password
      MYSQL_DATABASE: keycloak
      MYSQL_USER: keycloak
      MYSQL_PASSWORD_FILE: /run/secrets/mysql_keycloak_password
      TZ: Asia/Shanghai
    secrets:
      - mysql_root_password
      - mysql_keycloak_password
    networks:
      - keycloak-internal
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "keycloak", "-p$$(cat /run/secrets/mysql_keycloak_password)"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 30s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '1.0'
        reservations:
          memory: 512M
          cpus: '0.5'

  # Keycloak 身份认证服务
  keycloak:
    container_name: keycloak-app
    image: quay.io/keycloak/keycloak:26.2.5-0
    depends_on:
      mysql:
        condition: service_healthy
    ports:
      - "8443:8443"  # 只暴露HTTPS端口
    volumes:
      - ./keycloak/conf:/opt/keycloak/conf:ro
      - ./keycloak/themes:/opt/keycloak/themes:ro
      - ./keycloak/providers:/opt/keycloak/providers:ro
      - keycloak_data:/opt/keycloak/data
      - /etc/localtime:/etc/localtime:ro
    environment:
      # 管理员配置
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD_FILE: /run/secrets/keycloak_admin_password
      
      # 数据库配置
      KC_DB: mysql
      KC_DB_USERNAME: keycloak
      KC_DB_PASSWORD_FILE: /run/secrets/mysql_keycloak_password
      KC_DB_URL: jdbc:mysql://mysql:3306/keycloak?useSSL=true&requireSSL=true&verifyServerCertificate=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai
      
      # 生产环境配置
      KC_HOSTNAME: your-domain.com  # 替换为实际域名
      KC_HOSTNAME_STRICT: "true"
      KC_HOSTNAME_STRICT_HTTPS: "true"
      KC_HTTP_ENABLED: "false"
      KC_HTTPS_CERTIFICATE_FILE: /opt/keycloak/conf/tls.crt
      KC_HTTPS_CERTIFICATE_KEY_FILE: /opt/keycloak/conf/tls.key
      
      # 性能和缓存配置
      KC_CACHE: ispn
      KC_CACHE_STACK: kubernetes
      
      # 日志配置
      KC_LOG_LEVEL: INFO
      KC_LOG_CONSOLE_OUTPUT: json
      
      # 安全配置
      KC_SPI_TRUSTSTORE_FILE_FILE: /opt/keycloak/conf/truststore.p12
      KC_SPI_TRUSTSTORE_FILE_PASSWORD_FILE: /run/secrets/truststore_password
      
      # JVM 配置
      JAVA_OPTS_APPEND: >-
        -Xms512m -Xmx1024m
        -XX:MetaspaceSize=96M
        -XX:MaxMetaspaceSize=256m
        -Djava.net.preferIPv4Stack=true
        -Dfile.encoding=UTF-8
    secrets:
      - keycloak_admin_password
      - mysql_keycloak_password
      - truststore_password
    networks:
      - keycloak-internal
      - keycloak-external
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "curl -f https://localhost:8443/health/ready || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "5"
    deploy:
      resources:
        limits:
          memory: 1.5G
          cpus: '2.0'
        reservations:
          memory: 1G
          cpus: '1.0'
    command:
      - start
      - --optimized

  # Nginx 反向代理 (可选)
  nginx:
    container_name: keycloak-nginx
    image: nginx:1.25-alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - ./ssl:/etc/ssl/certs:ro
      - nginx_logs:/var/log/nginx
    depends_on:
      - keycloak
    networks:
      - keycloak-external
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "nginx", "-t"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

# 网络配置
networks:
  keycloak-internal:
    driver: bridge
    internal: true  # 内部网络，不能访问外网
  keycloak-external:
    driver: bridge

# 数据卷
volumes:
  mysql_data:
    driver: local
  keycloak_data:
    driver: local
  nginx_logs:
    driver: local

# 密钥管理
secrets:
  mysql_root_password:
    file: ./secrets/mysql_root_password.txt
  mysql_keycloak_password:
    file: ./secrets/mysql_keycloak_password.txt
  keycloak_admin_password:
    file: ./secrets/keycloak_admin_password.txt
  truststore_password:
    file: ./secrets/truststore_password.txt
```