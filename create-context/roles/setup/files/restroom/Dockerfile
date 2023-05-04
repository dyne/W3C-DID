
# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2021-2023 Dyne.org foundation <foundation@dyne.org>.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

ARG NODE_VERSION=16
FROM node:$NODE_VERSION-alpine

WORKDIR /app

# Add dependencies
RUN apk add git python3 make g++

# Installing restroom
COPY restroom.mjs .
COPY yarn.lock .
COPY package.json .

# Configure restroom
ENV HTTP_PORT=3000
ENV HTTPS_PORT=3301
ENV OPENAPI=true
ENV CHAIN_EXT=chain
ENV YML_EXT=yml

RUN mkdir -p /var/contracts
RUN yarn

# yarn install and run
CMD yarn start
