FROM node:latest as build
LABEL maintainer="chrisae9@gmail.com"

WORKDIR /website

COPY /website/package.json .
RUN npm update
RUN npm install

COPY /website .

CMD [ "npm", "run", "serve" ]