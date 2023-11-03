# 阶段 1: 构建阶段
# 使用 Jekyll 官方镜像作为基础来构建静态文件
FROM jekyll/jekyll:latest as builder

# 设置工作目录
WORKDIR /srv/jekyll

# 复制 Gemfile 和 Gemfile.lock 到工作目录
COPY Gemfile Gemfile.lock /srv/jekyll/
USER root
RUN chmod 666 /srv/jekyll/Gemfile.lock

# 安装依赖项
RUN bundle install

# 复制网站源码到容器中
COPY . /srv/jekyll/

# 构建静态文件
RUN jekyll build

# 阶段 2: 部署阶段
# 使用轻量级的 Nginx 镜像来部署网站
FROM nginx:alpine

# 从构建阶段复制生成的静态文件到 Nginx 的目录
COPY --from=builder /srv/jekyll/_site /usr/share/nginx/html

# 设置环境变量
ENV PORT=8080 HOST=0.0.0.0

# 暴露端口
EXPOSE 8080

# 配置 Nginx
# 可以在这里添加自定义 Nginx 配置，如果需要的话
# COPY nginx.conf /etc/nginx/nginx.conf

# 使用 Nginx 镜像的默认 CMD 启动命令，无需修改
