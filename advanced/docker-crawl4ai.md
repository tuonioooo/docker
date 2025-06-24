# crawl4ai爬虫容器部署


官网：https://github.com/unclecode/crawl4ai

Docker镜像：https://hub.docker.com/r/unclecode/crawl4ai

### 模版

* [crawl4ai](./yml/docker-compose-crawl4ai.yml)

### 简单测试的示例

```
curl -X POST http://localhost:11235/crawl \
  -H "Content-Type: application/json" \
  -d '{"urls": ["https://example.com"]}'

```