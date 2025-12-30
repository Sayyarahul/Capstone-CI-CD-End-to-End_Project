# ---------- Test stage ----------
FROM node:18-alpine AS frontend-test
WORKDIR /app

COPY package.json .
RUN npm install

COPY . .
RUN npm test

# ---------- Production stage ----------
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY app.js /usr/share/nginx/html/
