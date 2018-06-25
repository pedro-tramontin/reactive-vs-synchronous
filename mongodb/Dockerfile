FROM mongo:3.6.5
COPY init-db.js /docker-entrypoint-initdb.d/
CMD ["mongod", "--smallfiles"]
