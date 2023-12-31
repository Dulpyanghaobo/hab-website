# 阶段 1: 构建阶段
# 使用 Jekyll 官方镜像作为基础来构建静态文件
FROM jekyll/jekyll:latest as builder
# 设置工作目录
WORKDIR /srv/jekyll
# 给工作目录赋予权限
RUN chmod 777 -R /srv/jekyll

# 复制 Gemfile 和 Gemfile.lock
COPY Gemfile* /srv/jekyll/

# 安装依赖项
RUN bundle install

# 复制网站源码到容器中，除了 Gemfile.lock，因为它已经被修改和复制过了
COPY . /srv/jekyll/
RUN rm -f /srv/jekyll/Gemfile.lock


# 构建静态文件
RUN jekyll build

# 阶段 2: 部署阶段
# 使用轻量级的 Nginx 镜像来部署网站
FROM nginx:alpine

# 从构建阶段复制生成的静态文件到 Nginx 的目录
COPY --from=builder /srv/jekyll/_site /usr/share/nginx/html

EXPOSE 8080

# 默认情况下，Nginx 会在启动时自动加载 /etc/nginx/conf.d 目录下的配置文件
# 如果你需要添加或修改 Nginx 配置，你可以添加一个新的配置文件到该目录
# COPY your-custom-nginx-config.conf /etc/nginx/conf.d/

# 无需添加启动 Nginx 的 CMD 指令，因为使用的是官方的 Nginx 镜像，
# 它默认会执行 'nginx -g daemon off;' 命令来启动服务
