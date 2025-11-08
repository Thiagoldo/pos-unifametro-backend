# Stage 1: Build the React frontend
FROM node:20-alpine as builder

WORKDIR /app

COPY ./frontend/package*.json ./
RUN npm install

COPY ./frontend ./
RUN npm run build

# Stage 2: Set up Nginx
FROM nginx:1.27-alpine

COPY --from=builder /app/build /usr/share/nginx/html
COPY ./nginx/config/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80