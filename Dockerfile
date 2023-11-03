# 阶段 1: 构建阶段
# 使用 Jekyll 官方镜像作为基础来构建静态文件
FROM jekyll/jekyll:4.2.0 as builder

# 复制 Gemfile 和 Gemfile.lock
COPY Gemfile* /srv/jekyll/

# 安装依赖项
RUN bundle install

# 复制网站源码到容器中
COPY . /srv/jekyll

# 设置工作目录
WORKDIR /srv/jekyll

## 这里的 BUILDTIME_ENV_EXAMPLE 会自动在建置前被设置
ARG BUILDTIME_ENV_EXAMPLE
ENV BUILDTIME_ENV_EXAMPLE=${BUILDTIME_ENV_EXAMPLE}

# 构建静态文件
RUN jekyll build

# 阶段 2: 部署阶段
# 使用轻量级的 Nginx 镜像来部署网站
FROM nginx:alpine

# 从构建阶段复制生成的静态文件到 Nginx 的目录
COPY --from=builder /srv/jekyll/_site /usr/share/nginx/html

ENV \
    PORT=8080 \
    HOST=0.0.0.0
 
EXPOSE 8080

# 默认情况下，Nginx 会在启动时自动加载 /etc/nginx/conf.d 目录下的配置文件
# 如果你需要添加或修改 Nginx 配置，你可以添加一个新的配置文件到该目录
# COPY your-custom-nginx-config.conf /etc/nginx/conf.d/

# 无需添加启动 Nginx 的 CMD 指令，因为使用的是官方的 Nginx 镜像，
# 它默认会执行 'nginx -g daemon off;' 命令来启动服务
