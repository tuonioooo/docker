#!/bin/bash

# Docker 容器挂载卷检测脚本
# 作者: Docker 管理工具
# 功能: 检测所有容器的挂载卷详细信息

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印分隔线
print_separator() {
    echo -e "${BLUE}============================================================${NC}"
}

# 打印标题
print_title() {
    echo -e "${GREEN}🐳 Docker 容器挂载卷详细信息检测工具${NC}"
    echo -e "${CYAN}检测时间: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    print_separator
}

# 检查 Docker 是否运行
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        echo -e "${RED}❌ Docker 未运行或无权限访问 Docker${NC}"
        exit 1
    fi
}

# 获取所有容器（包括停止的）
get_all_containers() {
    docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" | tail -n +2
}

# 检测单个容器的挂载信息
inspect_container_mounts() {
    local container_name=$1
    local container_status=$2
    local container_image=$3
    
    echo -e "\n${YELLOW}📦 容器名称: ${container_name}${NC}"
    echo -e "${CYAN}   状态: ${container_status}${NC}"
    echo -e "${CYAN}   镜像: ${container_image}${NC}"
    echo -e "${PURPLE}   挂载信息:${NC}"
    
    # 检查是否有挂载
    local has_mounts=$(docker inspect "$container_name" --format='{{len .Mounts}}' 2>/dev/null)
    
    if [ "$has_mounts" = "0" ] || [ -z "$has_mounts" ]; then
        echo -e "     ${RED}❌ 无挂载卷${NC}"
        return
    fi
    
    # Volume 挂载
    echo -e "   ${GREEN}📁 Volume 挂载:${NC}"
    local volumes=$(docker inspect "$container_name" --format='{{range .Mounts}}{{if eq .Type "volume"}}{{.Name}}|{{.Destination}}|{{.Mode}}|{{.RW}}{{printf "\n"}}{{end}}{{end}}' 2>/dev/null)
    
    if [ -z "$volumes" ]; then
        echo -e "     ${YELLOW}⚠️  无 Volume 挂载${NC}"
    else
        echo "$volumes" | while IFS='|' read -r name dest mode rw; do
            [ -z "$name" ] && continue
            echo -e "     ${CYAN}➤ 卷名: ${name}${NC}"
            echo -e "       目标路径: ${dest}"
            echo -e "       模式: ${mode}"
            echo -e "       读写权限: $([ "$rw" = "true" ] && echo "读写" || echo "只读")"
            echo
        done
    fi
    
    # Bind Mount 挂载
    echo -e "   ${GREEN}🔗 Bind Mount 挂载:${NC}"
    local binds=$(docker inspect "$container_name" --format='{{range .Mounts}}{{if eq .Type "bind"}}{{.Source}}|{{.Destination}}|{{.Mode}}|{{.RW}}{{printf "\n"}}{{end}}{{end}}' 2>/dev/null)
    
    if [ -z "$binds" ]; then
        echo -e "     ${YELLOW}⚠️  无 Bind Mount 挂载${NC}"
    else
        echo "$binds" | while IFS='|' read -r source dest mode rw; do
            [ -z "$source" ] && continue
            echo -e "     ${CYAN}➤ 源路径: ${source}${NC}"
            echo -e "       目标路径: ${dest}"
            echo -e "       模式: ${mode}"
            echo -e "       读写权限: $([ "$rw" = "true" ] && echo "读写" || echo "只读")"
            # 检查源路径是否存在
            if [ -e "$source" ]; then
                echo -e "       状态: ${GREEN}✅ 源路径存在${NC}"
            else
                echo -e "       状态: ${RED}❌ 源路径不存在${NC}"
            fi
            echo
        done
    fi
    
    # tmpfs 挂载
    echo -e "   ${GREEN}💾 tmpfs 挂载:${NC}"
    local tmpfs=$(docker inspect "$container_name" --format='{{range .Mounts}}{{if eq .Type "tmpfs"}}{{.Destination}}|{{.Mode}}{{printf "\n"}}{{end}}{{end}}' 2>/dev/null)
    
    if [ -z "$tmpfs" ]; then
        echo -e "     ${YELLOW}⚠️  无 tmpfs 挂载${NC}"
    else
        echo "$tmpfs" | while IFS='|' read -r dest mode; do
            [ -z "$dest" ] && continue
            echo -e "     ${CYAN}➤ 目标路径: ${dest}${NC}"
            echo -e "       模式: ${mode}"
            echo
        done
    fi
}

# 生成统计信息
generate_statistics() {
    echo -e "\n${GREEN}📊 统计信息${NC}"
    print_separator
    
    local total_containers=$(docker ps -a --format "{{.Names}}" | wc -l)
    local running_containers=$(docker ps --format "{{.Names}}" | wc -l)
    local total_volumes=$(docker volume ls -q | wc -l)
    
    echo -e "${CYAN}总容器数: ${total_containers}${NC}"
    echo -e "${CYAN}运行中容器: ${running_containers}${NC}"
    echo -e "${CYAN}停止容器: $((total_containers - running_containers))${NC}"
    echo -e "${CYAN}系统卷总数: ${total_volumes}${NC}"
    
    # 统计各类型挂载的容器数量
    local containers_with_volumes=0
    local containers_with_binds=0
    local containers_with_tmpfs=0
    
    docker ps -a --format "{{.Names}}" | while read -r container; do
        local vol_count=$(docker inspect "$container" --format='{{range .Mounts}}{{if eq .Type "volume"}}1{{end}}{{end}}' 2>/dev/null | wc -c)
        local bind_count=$(docker inspect "$container" --format='{{range .Mounts}}{{if eq .Type "bind"}}1{{end}}{{end}}' 2>/dev/null | wc -c)
        local tmpfs_count=$(docker inspect "$container" --format='{{range .Mounts}}{{if eq .Type "tmpfs"}}1{{end}}{{end}}' 2>/dev/null | wc -c)
        
        [ "$vol_count" -gt 0 ] && containers_with_volumes=$((containers_with_volumes + 1))
        [ "$bind_count" -gt 0 ] && containers_with_binds=$((containers_with_binds + 1))  
        [ "$tmpfs_count" -gt 0 ] && containers_with_tmpfs=$((containers_with_tmpfs + 1))
    done
}

# 显示帮助信息
show_help() {
    echo -e "${GREEN}使用方法:${NC}"
    echo -e "  $0 [选项] [容器名称]"
    echo -e "\n${GREEN}选项:${NC}"
    echo -e "  -h, --help     显示帮助信息"
    echo -e "  -a, --all      检测所有容器（默认）"
    echo -e "  -r, --running  仅检测运行中的容器"
    echo -e "  -s, --stats    显示统计信息"
    echo -e "\n${GREEN}示例:${NC}"
    echo -e "  $0                    # 检测所有容器"
    echo -e "  $0 -r                 # 仅检测运行中的容器"
    echo -e "  $0 nginx              # 检测指定容器"
    echo -e "  $0 -s                 # 显示统计信息"
}

# 主函数
main() {
    local show_all=true
    local show_running=false
    local show_stats=false
    local specific_container=""
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -a|--all)
                show_all=true
                shift
                ;;
            -r|--running)
                show_running=true
                show_all=false
                shift
                ;;
            -s|--stats)
                show_stats=true
                shift
                ;;
            -*)
                echo -e "${RED}未知选项: $1${NC}"
                show_help
                exit 1
                ;;
            *)
                specific_container="$1"
                shift
                ;;
        esac
    done
    
    print_title
    check_docker
    
    if [ "$show_stats" = true ]; then
        generate_statistics
        exit 0
    fi
    
    # 检测指定容器
    if [ -n "$specific_container" ]; then
        if docker ps -a --format "{{.Names}}" | grep -q "^${specific_container}$"; then
            local status=$(docker ps -a --filter "name=^${specific_container}$" --format "{{.Status}}")
            local image=$(docker ps -a --filter "name=^${specific_container}$" --format "{{.Image}}")
            inspect_container_mounts "$specific_container" "$status" "$image"
        else
            echo -e "${RED}❌ 容器 '${specific_container}' 不存在${NC}"
            exit 1
        fi
        exit 0
    fi
    
    # 获取容器列表
    local container_list
    if [ "$show_running" = true ]; then
        container_list=$(docker ps --format "{{.Names}}\t{{.Status}}\t{{.Image}}")
        echo -e "${CYAN}🔍 检测运行中的容器...${NC}"
    else
        container_list=$(docker ps -a --format "{{.Names}}\t{{.Status}}\t{{.Image}}")
        echo -e "${CYAN}🔍 检测所有容器...${NC}"
    fi
    
    if [ -z "$container_list" ]; then
        echo -e "${YELLOW}⚠️  没有找到容器${NC}"
        exit 0
    fi
    
    # 检测每个容器
    echo "$container_list" | while IFS=$'\t' read -r name status image; do
        inspect_container_mounts "$name" "$status" "$image"
        print_separator
    done
    
    echo -e "\n${GREEN}✅ 检测完成！${NC}"
}

# 执行主函数
main "$@"