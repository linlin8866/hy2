#!/bin/bash

# 确保脚本在 /root 目录下执行
cd /root

if [ ! -f "hysteria" ]; then
    echo "❌ 错误：未在 /root 目录下找到名为 hysteria 的二进制文件，请先上传！"
    exit 1
fi

echo "📦 正在安装 Hysteria 2 二进制文件..."
mv /root/hysteria /usr/local/bin/hysteria
chmod +x /usr/local/bin/hysteria
echo "✅ Hysteria 2 二进制文件安装成功！"

echo "🔒 正在生成自签名证书 (有效期 10 年)..."
mkdir -p /etc/hysteria
openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/hysteria/server.key -out /etc/hysteria/server.crt -days 3650 -subj "/CN=bing.com"
chmod 600 /etc/hysteria/server.key
chmod 644 /etc/hysteria/server.crt

# 【纯离线模式】不依赖任何外部网络获取IP，密码由本地随机生成
SERVER_IP="你的服务器IP"
PASSWORD=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9')

echo "🛠️ 正在生成双栈服务端配置文件..."
# listen 设为 :36789 会默认同时监听 IPv4 和 IPv6
cat <<EOF > /etc/hysteria/config.yaml
listen: :36789

tls:
  cert: /etc/hysteria/server.crt
  key: /etc/hysteria/server.key

auth:
  type: password
  password: "$PASSWORD"

masquerade:
  type: proxy
  proxy:
    url: https://www.bing.com
    rewriteHost: true

fastOpen: true
EOF

echo "🚀 正在配置 IPv4/IPv6 双栈端口跳跃 (Port Hopping)..."

# === 1. IPv4 防火墙配置 ===
iptables -A INPUT -p udp --dport 36789 -j ACCEPT
iptables -t nat -A PREROUTING -p udp --dport 40000:50000 -j REDIRECT --to-ports 36789

# 持久化 IPv4 规则
if command -v iptables-save &> /dev/null; then
    mkdir -p /etc/iptables
    iptables-save > /etc/iptables/rules.v4
fi

# === 2. IPv6 防火墙配置 ===
# 放行 IPv6 主端口
ip6tables -A INPUT -p udp --dport 36789 -j ACCEPT
# 开启 IPv6 的端口跳跃（将 IPv6 的 40000-50000 流量转发到 36789）
ip6tables -t nat -A PREROUTING -p udp --dport 40000:50000 -j REDIRECT --to-ports 36789

# 持久化 IPv6 规则
if command -v ip6tables-save &> /dev/null; then
    mkdir -p /etc/iptables
    ip6tables-save > /etc/iptables/rules.v6
fi

echo "✅ 双栈防火墙及端口跳跃规则配置完成！"

echo "⚙️ 正在创建 Systemd 系统服务..."
cat <<EOF > /etc/systemd/system/hysteria.service
[Unit]
Description=Hysteria 2 Server (Dual Stack)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/etc/hysteria
ExecStart=/usr/local/bin/hysteria server -c /etc/hysteria/config.yaml
Restart=always
RestartSec=5
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 正在启动 Hysteria 2 服务..."
systemctl daemon-reload
systemctl enable hysteria
systemctl restart hysteria

# 检查服务运行状态
if systemctl is-active --quiet hysteria; then
    echo -e "\n=================================================="
    echo -e "🎉 \033[32mHysteria 2 纯离线双栈（v4+v6）部署成功！\033[0m"
    echo -e "=================================================="
    echo -e "🔑 连接密码: \033[33m$PASSWORD\033[0m"
    echo -e "🌐 主端口: \033[35m36789\033[0m (UDP)"
    echo -e "🦘 端口跳跃范围: \033[35m40000-50000\033[0m (UDP)"
    echo -e "=================================================="
    echo -e "\n👇 \033[32m请复制下面的客户端配置模板使用：\033[0m"
    echo -e "--------------------------------------------------"
    cat <<EOF
# ⚠️ 注意：如果你用 IPv6 连接，请将下面第一行改为：[你的IPv6地址]:36789
server: $SERVER_IP:36789
hop: 40000-50000
auth: $PASSWORD
tls:
  sni: www.bing.com
  insecure: true

# ⚠️ 极其重要：务必根据你家里的真实测速打 8 折填写
bandwidth:
  up: 30mbps
  down: 300mbps

fastOpen: true
lazy: true
EOF
    echo -e "--------------------------------------------------"
else
    echo "❌ 服务启动失败，请检查配置或使用 journalctl -u hysteria 查看日志"
fi
