FROM node:alpine
LABEL maintainer="chrisae9@gmail.com"

WORKDIR /website

COPY /website/package.json .
RUN npm update
RUN npm install

# copy the whole source folder(the dir is relative to the Dockerfile
COPY /website .

CMD [ "npm", "run", "start" ]