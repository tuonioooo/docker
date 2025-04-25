# Docker Compose 锚点的用法


## 概念

锚点（Anchor）：

- 锚点允许你在 YAML 文件中为一个部分定义一个名字，通常是通过 & 来定义。

- 这允许你在文件的其他地方引用这部分内容，而不需要重复编写相同的内容。

引用（Alias）：

- 引用通过 * 来使用，引用了某个之前定义的锚点的内容。

- 这样，引用就可以将已经定义的内容复制到当前的位置。


## 示例：

假设在 docker-compose.yml 中，你有一段定义了多个构建参数的部分：

```yml
version: '3'
x-build_args: &build_args  # 这里定义了一个锚点
  INSTALL_PYTHON_VERSION: "3.9"
  INSTALL_NODE_VERSION: "16"

services:
  flask-dev:
    build:
      context: .
      target: development
      args:
        <<: *build_args  # 使用锚点引用之前定义的内容

```

### 解释：

- `x-build_args: &build_args` 定义了一个名为 `build_args` 的锚点（`&build_args`），其中存储了一些构建参数，如 `INSTALL_PYTHON_VERSION` 和 `INSTALL_NODE_VERSION`。
- 然后，在 `flask-dev` 服务的 `build` 部分，使用了 `<<: *build_args`，这意味着将 `build_args` 中定义的内容插入到 `args` 部分中。

### 结果：

`args: <<: *build_args` 会把锚点 `build_args` 中的内容展开到 `args` 部分，等价于：

```yaml
args:
  INSTALL_PYTHON_VERSION: "3.9"
  INSTALL_NODE_VERSION: "16"
```

这样，`args` 就包含了这些构建参数，而无需重复编写它们。

### 总结：

- `<<: *build_args` 是 YAML 中的引用语法，表示将 `build_args` 中定义的内容插入到当前位置。
- 通过这种方式，你可以避免重复写相同的配置，使得文件更加简洁和易于维护。