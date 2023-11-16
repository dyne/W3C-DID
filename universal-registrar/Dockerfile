ARG NODE_VERSION=18
FROM node:$NODE_VERSION-alpine

WORKDIR /app

# Add dependencies
RUN apk add redis --no-cache

# contracts folders
RUN mkdir -p /var/contracts

# copy contracts and env
COPY contracts/* /var/contracts/
COPY restroom.mjs .
COPY package.json .
COPY yarn.lock .
COPY .env.docker .env

# expose port
EXPOSE 3000

#  copy start script
COPY start.sh .
RUN chmod +x start.sh

# yarn start
ENTRYPOINT ["sh", "/app/start.sh"]
