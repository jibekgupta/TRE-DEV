FROM nginx:1.27-alpine
COPY hello-world/ /usr/share/nginx/html/
EXPOSE 80
