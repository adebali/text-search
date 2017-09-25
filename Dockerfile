FROM node:7.8.0-alpine

LABEL io.k8s.description="text-search applcication" \
 io.k8s.display-name="text-search APP" \
 io.openshift.expose-services="3000:http"

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
RUN apk update && apk upgrade && apk add git

COPY . /usr/src/app/
RUN npm install

# Build app
RUN npm run build

ENV HOST 0.0.0.0
USER 1001
EXPOSE 3000

# start command
CMD [ "npm", "start" ]
