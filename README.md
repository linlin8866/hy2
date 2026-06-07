上传root统一hysteria

bash <(curl -L https://raw.githubusercontent.com/linlin8866/hy2/main/ip.sh)

curl -O https://raw.githubusercontent.com/linlin8866/hy2/main/ip.sh
chmod +x ip.sh
./ip.sh


proxies:
  - name: "🦘 Hy2-500M双栈狂暴节点"
    type: hysteria2
    server: 38.179.87.22             # 你的服务器 IPv4 地址
    port: 36789
    ports: 40000-50000              # 开启端口跳跃，绕过晚高峰 QoS
    password: Fn5tNDcg6tIvZfxsnoouog # 你的连接密码
    sni: www.bing.com
    skip-cert-verify: true          # 自签名证书必须跳过验证
    
    # 👇 已经为你完美适配 500M 宽带的 8 折参数
    up: 40mbps                      # 对应你家约 50M 的上传
    down: 400mbps                   # 对应你家 500M 的下载
    
    fast-open: true



