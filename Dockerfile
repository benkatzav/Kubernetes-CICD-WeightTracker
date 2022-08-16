# Use node 14 with alpine OS
FROM node:14-alpine
LABEL maintainer="Ben Katzav"
LABEL dateCreated="04-07-2022"
COPY . /bootcamp-app
WORKDIR /bootcamp-app

# Open communication on port 8080
EXPOSE 8080

# Installing dependencies
RUN npm install
CMD npm run initdb && npm run dev