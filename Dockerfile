# 1️⃣ Build 階段
FROM node:20-alpine AS build

WORKDIR /app

# 複製 package.json + lock file，安裝依賴
COPY package*.json ./
RUN npm install

# 複製專案原始碼
COPY . .

# 建置 React 靜態檔
RUN npm run build

# 2️⃣ Production 階段，使用 Nginx 提供靜態檔
FROM nginx:alpine

# 複製 build 結果到 Nginx 預設服務目錄
COPY --from=build /app/dist /usr/share/nginx/html

# 複製自訂 Nginx 設定（如果有需要）
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# 對外暴露 80 port
EXPOSE 80

# 啟動 Nginx
CMD ["nginx", "-g", "daemon off;"]
