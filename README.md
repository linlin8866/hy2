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



proxies:
  - name: "🦘 Hy2-双栈狂暴节点"
    type: hysteria2
    server: 你的服务器IP             # ⚠️ 替换为你的服务器 IPv4 或 [IPv6] 地址
    port: 36789
    ports: 40000-50000              # 开启端口跳跃，绕过晚高峰 QoS
    password: Fn5tNDcg6tIvZfxsnoouog # 你的连接密码
    sni: www.bing.com
    skip-cert-verify: true          # 因为是自签名证书，必须开启跳过证书验证
    
    # ⚠️ 极其重要：务必根据你家里的真实国内宽带测速结果（Speedtest）打 8 折填写
    # 比如你家里下载 500M / 上传 50M，这里就填 400mbps 和 40mbps。
    # 如果删掉或写太大，会导致严重的网络自我“撑爆”卡顿！
    up: 24mbps                      
    down: 240mbps                   
    
    fast-open: true



proxies:
  - name: "🦘 Hy2-双栈狂暴节点"
    type: hysteria2
    server: 38.179.87.22             # 👈 已经为你填入你的 IPv4 地址
    port: 36789
    ports: 40000-50000              # 开启端口跳跃，绕过晚高峰 QoS
    password: Fn5tNDcg6tIvZfxsnoouog # 你的连接密码
    sni: www.bing.com
    skip-cert-verify: true          # 因为是自签名证书，必须开启跳过证书验证
    
    # ⚠️ 极其重要：务必根据你家里的真实国内宽带测速结果（Speedtest）打 8 折填写
    # 比如你家里下载 500M / 上传 50M，这里就填 400mbps 和 40mbps。
    # 这一行是 Hy2 推土机算法的上限，写得太高或删掉会导致严重的网络自我“撑爆”卡顿！
    up: 24mbps                      
    down: 240mbps                   
    
    fast-open: true
