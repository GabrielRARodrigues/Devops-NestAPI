FROM node:22-alpine3.22 AS build

WORKDIR /usr/src/app

COPY . ./
COPY package.json package-lock.json ./

RUN npm i
RUN npm run build

RUN npm ci --only=production

FROM node:22-alpine3.22 AS production

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "run", "start:prod"]