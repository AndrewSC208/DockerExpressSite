# LINKING
# Build: docker build -f Dockerfile -t generalsherman/node .
# Build: twitter server: docker build -f Dockerfile -t tweetjudo/node . 


# OPTION 1: Start MongoDB and Node (link Node to MongoDB container with legacy linking)
# STEP ONE: Run mongodb and give it a name
# docker run -d --name my-mongodb mongo
# docker run -d --name twitterdb mongo
# STEP TWO: Start Node and link to MongoDB container
# docker run -d -p 3000:3000 --link my-mogodb:mongodb generalsherman/node

# OPTION 2: Create a custom bridge network and add containers into it
# STEP ONE: Create local network bridge
# docker network create --driver bridge isolated_network

# STEP TWO: Run mongoDB on isolated network:
# docker run -d --net=isolated_network --name mongodb mongo

# STEP THREE: Run node app:
# docker run -d --net=isolated_network --name nodeapp -p 3000:3000 generalsherman/node

# OPTINAL SEED DB STEP:
# docker exec tweetjudo node dbSeeder.js


FROM node:latest

MAINTAINER Andrew Meiling

ENV NODE_ENV=production
ENV PORT=3000

COPY . /var/www
WORKDIR /var/www

RUN npm install

EXPOSE $PORT

ENTRYPOINT ["npm", "start"]