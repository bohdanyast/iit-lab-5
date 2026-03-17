FROM nginx

COPY index.html /usr/share/nginx/html/index.html
COPY style.css /usr/share/nginx/html/style.css

COPY images/artem.png /usr/share/nginx/html/images/artem.png
COPY images/bohdan.png /usr/share/nginx/html/images/bohdan.png
COPY images/gleb.png /usr/share/nginx/html/images/gleb.png

EXPOSE 80