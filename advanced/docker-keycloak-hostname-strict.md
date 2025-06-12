## `hostname-strict` 参数详解

### 功能说明

默认情况下，Keycloak 要求配置 hostname 选项并且不会动态解析 URL。这是一个安全措施。

### 安全原理

Keycloak 会自由地披露自己的 URL，例如通过 OIDC Discovery 端点，或作为电子邮件中密码重置链接的一部分。如果主机名是从主机名头动态解释的，它可能为潜在攻击者提供操作电子邮件中 URL 的机会，将用户重定向到攻击者的虚假域，并窃取敏感数据，如操作令牌、密码等。

### 配置选项

**生产环境（默认 `hostname-strict = true`）**

```bash
# 必须显式配置 hostname 或设置 hostname-strict=false
bin/kc.sh start --hostname my.keycloak.org
```

**开发环境（默认 `hostname-strict = false`）**

```bash
# 开发模式下默认允许动态解析
bin/kc.sh start-dev
```

### Docker 配置示例

**启用严格模式（生产推荐）**

```yaml
keycloak:
  environment:
    KC_HOSTNAME: https://my.keycloak.org
    KC_HOSTNAME_STRICT: "true"  # 生产环境默认值
  command:
    - start
    - --hostname=https://my.keycloak.org
```

**禁用严格模式（开发/测试）**

```yaml
keycloak:
  environment:
    KC_HOSTNAME_STRICT: "false"
  command:
    - start-dev
    - --hostname-strict=false
```

### 代理配置场景

**使用反向代理时**

```yaml
keycloak:
  environment:
    KC_HOSTNAME_STRICT: "false"
    KC_PROXY_HEADERS: "forwarded"  # 或 "xforwarded"
  command:
    - start
    - --hostname-strict=false
    - --proxy-headers=forwarded
```

### 验证规则

根据官方文档，以下验证规则适用：

1. **生产模式下**：必须显式配置 `--hostname` 或 `--hostname-strict=false`

2. **开发模式下**：`--hostname-strict=false` 是默认值

3. 如果未配置 hostname

   ：

   - `hostname-backchannel-dynamic` 必须设置为 false
   - `hostname-strict` 必须设置为 false

### 调试工具

要排查主机名配置问题，可以使用专用的调试工具：

```bash
bin/kc.sh start --hostname=mykeycloak --hostname-debug=true
```

然后访问：`http://mykeycloak:8080/realms/<your-realm>/hostname-debug`

### 实际应用建议

**开发环境**

```yaml
environment:
  KC_HOSTNAME_STRICT: "false"
  KC_HTTP_ENABLED: "true"
command:
  - start-dev
  - --hostname-strict=false
```

**生产环境**

```yaml
environment:
  KC_HOSTNAME: "https://keycloak.example.com"
  KC_HOSTNAME_STRICT: "true"
command:
  - start
  - --hostname=https://keycloak.example.com
```

这个参数对于 Keycloak 的安全性非常重要，特别是在生产环境中防止主机名劫持攻击。