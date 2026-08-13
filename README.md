# Arch Linux Live CD with GUI

用于Arch Linux安装/救援的系统镜像，配置如下：

- Wayland + KDE桌面环境，带有Intel/AMD/NVIDIA/VirtIO显卡开源驱动
- Firefox浏览器
- OpenCode
- Nano/Vim/Kate文本编辑器
- 仅支持UEFI启动
- EROFS + Zstd压缩镜像
- oh-my-zsh + p10k环境
- 基于Zram的交换空间，最大8GB
- 安装Arch Linux所需的实用工具
- QEMU/Hyper-V/Virtual Box/VMWare虚拟化支持
- Clash Verge Rev（来自AUR的clash-verge-rev-bin）
- 删除了现代桌面环境下很少使用的包

## 构建

```bash
# 1. 构建AUR包并更新本地仓库
# 本地仓库储存在/tmp下，重启后会清空
./build.sh

# 2. 构建ISO（需要 root）
sudo mkarchiso -v .
```
