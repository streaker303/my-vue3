#!/usr/bin/env bash
set -e

echo "[+] 创建目录"
sudo mkdir -p /app/jenkins_home /app/shared-dist /app/nginx

echo "[+] 写 Nginx default.conf (若不存在)"
if [ ! -f /app/nginx/default.conf ]; then
  sudo tee /app/nginx/default.conf >/dev/null <<'EOF'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;
    location / { try_files $uri $uri/ /index.html; }
}
EOF
else
  echo "    已存在，跳过。"
fi

echo "[+] 写占位 index.html (若不存在)"
[ -f /app/shared-dist/index.html ] || echo "<h1>Waiting for build</h1>" | sudo tee /app/shared-dist/index.html >/dev/null

echo "[+] 设置 Jenkins 可写权限"
sudo chown -R 1000:1000 /app/jenkins_home /app/shared-dist || true

echo "[+] 启动 docker compose"
if docker compose version >/dev/null 2>&1; then
  docker compose up -d
else
  docker-compose up -d
fi

echo "[✓] 完成：Jenkins -> http://<host>:8080  Nginx -> http://<host>:80"
echo "查看初始密码： docker logs wj-jenkins | grep -i 'initialAdminPassword'"