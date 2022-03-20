## 基础镜像
FROM nginx

## author
MAINTAINER ouay

# 创建目录
RUN mkdir -p /home/ruoyi/projects/ruoyi-ui

# 指定路径
WORKDIR /home/ruoyi/projects/ruoyi-ui

# 复制conf文件到路径
COPY nginx/conf/nginx.conf /etc/nginx/nginx.conf

## 将 dist 目录拷贝到 nginx 容器 html 目录下
COPY dist /home/ruoyi/projects/ruoyi-ui

## 暴露端口
EXPOSE 80
