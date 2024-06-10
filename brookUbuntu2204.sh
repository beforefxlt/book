#!/bin/bash

# 检查是否以 root 用户运行脚本
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 用户运行此脚本。"
  exit 1
fi

# 提示用户输入密码
read -sp "请输入 Brook 服务密码: " BROOK_PASSWORD
echo

# 更新系统并安装依赖
echo "更新系统并安装依赖..."
apt update
apt upgrade -y
apt install wget -y

# 下载 Brook
echo "下载并安装 Brook..."
wget https://github.com/txthinking/brook/releases/download/v20240606/brook_linux_amd64 -O /usr/local/bin/brook
chmod +x /usr/local/bin/brook

# 创建 Brook 的 systemd 服务文件
echo "创建 Brook 的 systemd 服务文件..."
cat <<EOF > /etc/systemd/system/brook.service
[Unit]
Description=Brook Server
After=network.target

[Service]
ExecStart=/usr/local/bin/brook server -l :9000 -p $BROOK_PASSWORD
Restart=always
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 配置并启动 Brook 服务
echo "重新加载 systemd 配置并启动 Brook 服务..."
systemctl daemon-reload
systemctl start brook
systemctl enable brook


echo "Brook 服务器已成功安装并配置为系统服务。"
