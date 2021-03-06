# Build
FROM node:14-stretch AS build

WORKDIR /usr/src/app

COPY package*.json /usr/src/app/

RUN npm ci --only=production
 
# Run
FROM node:14-alpine

USER node

WORKDIR /usr/src/app

COPY --chown=node:node --from=build /usr/src/app/node_modules /usr/src/app/node_modules
COPY --chown=node:node . /usr/src/app

CMD ["node", "."]