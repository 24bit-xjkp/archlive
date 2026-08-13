#!/usr/bin/env bash
#
# Runs in a chroot during the ISO build.
set -euo pipefail

# Generate locales (en_US.UTF-8, zh_CN.UTF-8)
locale-gen

# Set the default timezone
ln -sfn /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# # Rewrite the mirrorlist.
# # pacman-mirrorlist overwrites /etc/pacman.d/mirrorlist during package
# # installation, so this must happen after pacstrap. In a shell context
# # $repo/$arch stay literal (unlike pacman hook Exec variables).
printf \
'Server = https://mirrors.nju.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.zju.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
' > /etc/pacman.d/mirrorlist
chmod 0644 /etc/pacman.d/mirrorlist

install -d /etc/skel

# Passwordless sudo for the desktop user
install -d -m 0755 /etc/sudoers.d
install -m 0440 /dev/stdin /etc/sudoers.d/10-arch <<'EOF'
arch ALL=(ALL) NOPASSWD: ALL
EOF

# oh-my-zsh with powerlevel10k theme and plugins for user 'arch'
OH_MY_ZSH='/home/arch/.oh-my-zsh'
git clone --depth=1 https://mirror.nju.edu.cn/git/ohmyzsh.git $OH_MY_ZSH
git clone --depth=1 https://mirrors.nju.edu.cn/git/powerlevel10k.git $OH_MY_ZSH/custom/themes/powerlevel10k
git clone --depth=1 https://mirrors.nju.edu.cn/git/zsh-autosuggestions.git $OH_MY_ZSH/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://mirrors.nju.edu.cn/git/zsh-syntax-highlighting.git $OH_MY_ZSH/custom/plugins/zsh-syntax-highlighting
chown -R arch:arch /home/arch

# Copy zsh configures for user 'root'
cp -r $OH_MY_ZSH /root
cp /etc/skel/.p10k_cli.zsh /etc/skel/.p10k.zsh /etc/skel/.zshrc /root

# Services: use NetworkManager instead of systemd-networkd, autologin into KDE via plasma-login
systemctl disable systemd-networkd.service systemd-networkd.socket systemd-networkd-wait-online.service
systemctl enable NetworkManager.service plasmalogin.service

# User services for audio (PipeWire) for all users
systemctl --global enable pipewire.socket pipewire-pulse.socket wireplumber.service

exit 0
