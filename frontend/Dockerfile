# # ==== CONFIGURE =====
# # Use a Node 16 base image
FROM node:16-alpine  as BUILD_IMAGE

# # ENV PORT 3000

# # Create app directory
# RUN mkdir -p /usr/src/app
# WORKDIR /usr/src/app

# # Installing dependencies
# COPY package*.json /usr/src/app/
# RUN yarn install

# # Copying source files
# COPY . /usr/src/app

# # Building app
# RUN yarn build
# EXPOSE 3000

# # Running the app
# FROM node:12-alpine

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

# install dependencies
RUN yarn --frozen-lockfile

COPY . .

# install node-prune (https://github.com/tj/node-prune)
# RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin


# build application
RUN yarn build
# install just production packages 
# RUN yarn prune --production


# run the prune command 
# RUN /usr/local/bin/node-prune


# use a fresh images 
FROM node:16-alpine 


WORKDIR /usr/src/app

# copy from build image
COPY --from=BUILD_IMAGE /usr/src/app/.next ./.next
COPY --from=BUILD_IMAGE /usr/src/app/node_modules ./node_modules
COPY package.json yarn.lock ./

# RUN yarn install --production=true

EXPOSE 3000


CMD ["yarn", "start"]