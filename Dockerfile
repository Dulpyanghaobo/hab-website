# 使用官方 Nginx 镜像作为基础镜像
FROM nginx:alpine

# 将你的站点内容复制到容器中的 /usr/share/nginx/html
# 这是 Nginx 默认的服务目录
COPY ./_site/ /usr/share/nginx/html

# 暴露 80 端口，Nginx 默认监听此端口
EXPOSE 80

# 使用默认的 Nginx 配置
# 如果你有自定义的 Nginx 配置文件，可以使用 COPY 指令覆盖默认配置
# 例如：COPY nginx.conf /etc/nginx/nginx.conf

# 当容器启动时运行 Nginx
# 由于使用的是官方的 Nginx 镜像，不需要手动编写 CMD 指令来启动 Nginx，
# 因为官方镜像已经配置了默认的启动命令
