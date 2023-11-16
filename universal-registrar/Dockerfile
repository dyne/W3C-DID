ARG NODE_VERSION=18
FROM node:$NODE_VERSION-alpine

WORKDIR /app

# Add dependencies
RUN apk add git python3 make g++

# contracts and files folders
RUN mkdir -p /var/contracts
RUN mkdir -p /var/files

# copy contracts and env
COPY contracts/* /var/contracts/
COPY restroom.mjs .
COPY package.json .
COPY yarn.lock .
COPY .env.docker .env

# install dependencies
RUN yarn

# copy crontab that eliminates all files in /var/files older than 1 day at 00:00 each day
RUN crontab -l | { cat; echo '0 0 * * * find /var/files/ -mtime +1 -exec rm {}'; } | crontab -

# yarn start
CMD ["crond", "&&", "yarn",  "start"]
