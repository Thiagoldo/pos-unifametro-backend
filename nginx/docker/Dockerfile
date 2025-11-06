# Stage 1: Build the React app
FROM node:18-alpine as frontend_builder

WORKDIR /app

COPY frontend/package*.json ./

RUN npm install

COPY frontend/. ./

RUN npm run build

FROM nginx:stable-alpine

COPY nginx/config/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=frontend_builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]