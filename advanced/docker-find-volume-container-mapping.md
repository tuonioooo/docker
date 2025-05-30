```bash
#!/bin/bash
# 脚本批量查找每个卷对应的容器：
echo "Volume -> Container mapping:"
echo "=========================="

for volume in $(docker volume ls -q); do
    containers=$(docker ps -a --filter volume=$volume --format "table {{.Names}}")
    if [ -n "$containers" ] && [ "$containers" != "NAMES" ]; then
        echo "Volume: $volume"
        echo "Containers: $containers"
        echo "---"
    fi
done
```

[脚本](../sh/find-volume-container-mapping.sh)