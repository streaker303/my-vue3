# 基础镜像：官方轻量版 Nginx 1.28.0（Alpine）
FROM nginx:1.28.0

# 不做额外修改：
# - 静态文件将通过 docker-compose 的卷挂载到 /usr/share/nginx/html
# - 如果后续需要 SPA fallback / gzip / 自定义 header，可再添加配置文件并 COPY 进来