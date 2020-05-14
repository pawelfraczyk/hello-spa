## Build Image
FROM node:12-alpine AS build
RUN npm install -g @angular/cli@9.1.0
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN ng build --prod

## Serve with nginx
FROM nginx:1.17.1-alpine
COPY --from=build /app/dist/hello-spa /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]