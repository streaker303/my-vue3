# 基础镜像：官方 Jenkins LTS，内置 Jenkins + JDK17
FROM jenkins/jenkins:lts-jdk17

# 切换到 root 安装系统工具
USER root

# 说明：
# 1. 更新 apt 索引
# 2. 安装前端构建常用工具：curl (下载脚本), git (拉代码), bash (nvm 依赖), build-essential (部分原生模块编译), ca-certificates (https 证书)
# 3. 安装后清理缓存减小镜像体积
RUN apt-get update && \
    apt-get install -y curl git bash build-essential ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# nvm 将被安装到 Jenkins 用户家目录下（持久化在 /var/jenkins_home）
ENV NVM_DIR=/var/jenkins_home/.nvm

# 安装 nvm（指定版本）并用 nvm 安装 Node 20，设为默认
# 使用 bash -lc 方式确保 nvm 初始化脚本被当前 shell 读取
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    bash -lc "nvm install 20 && nvm alias default 20"

# 将 nvm 初始化脚本写入 Jenkins 用户的 bashrc
# 之后在 Jenkins Pipeline 中使用：#!/bin/bash -lc "node -v" 即可访问 node/npm
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /var/jenkins_home/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> /var/jenkins_home/.bashrc

# （可选）预创建一个工作目录，与你 compose 里挂载的 /workspace/app 保持一致
RUN mkdir -p /workspace/app && chown -R jenkins:jenkins /workspace

# 切回 Jenkins 默认用户，避免后续以 root 运行（更安全）
USER jenkins

# 提示：
# 在 Jenkins 中执行 shell 步骤示例：
#   #!/bin/bash -lc
#   node -v
#   npm -v
#   npm ci
#   npm run build
#   rm -rf /var/www/dist/* && cp -r dist/* /var/www/dist/