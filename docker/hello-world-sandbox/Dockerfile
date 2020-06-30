FROM node:12.18.0-alpine3.10

WORKDIR /app

COPY . ./

RUN npm install --only=production

RUN chmod -R a+x /app

USER nobody

EXPOSE 9000
CMD ["npm", "start"]
