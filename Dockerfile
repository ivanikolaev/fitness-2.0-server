FROM node:20-alpine as base

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

EXPOSE 3001

CMD ["npm", "run", "dev"]