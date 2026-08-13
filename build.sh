#!/usr/bin/env bash
#
# 构建 AUR 包并更新本地仓库（供 archiso 构建时使用）
# 用法：./build.sh   （普通用户运行，无需 sudo）
#
# 注意：/tmp 在系统重启后会被清空，每次构建前重新运行本脚本即可。
#
set -euo pipefail

REPO_DIR=/tmp/archlive-localrepo
mkdir -p "$REPO_DIR"
AUR_PKG=clash-verge-rev-bin
WORK_DIR="$(mktemp -d /tmp/aur-build.XXXXXX)"
trap 'rm -rf -- "${WORK_DIR}"' EXIT

echo "==> 克隆 AUR 包: ${AUR_PKG}"
git clone --depth=1 "https://aur.archlinux.org/${AUR_PKG}.git" \
    "${WORK_DIR}/${AUR_PKG}"

echo "==> 构建包 (makepkg -s)"
cd "${WORK_DIR}/${AUR_PKG}"
makepkg -s --needed --noconfirm

echo "==> 更新本地仓库 ${REPO_DIR}"
install -d -m 0755 "${REPO_DIR}"
install -m 0644 ./*.pkg.tar.zst "${REPO_DIR}/"
repo-add -R "${REPO_DIR}/localrepo.db.tar.gz" \
    "${REPO_DIR}"/clash-verge-rev-bin-*.pkg.tar.zst

echo "==> 完成，现在可执行: sudo mkarchiso -v ."
