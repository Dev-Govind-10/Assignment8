# FROM node:16-alpine

# # Set environment variable for backend API
# ENV BACKEND_URL=http://localhost:8000/api

# # Set working directory
# WORKDIR /app

# # Copy only package.json first for better caching
# COPY frontend/package*.json ./

# # Install dependencies
# RUN npm install

# # Copy the rest of the app
# COPY frontend/ .

# # Expose port 3000 (the one your Express app uses)
# EXPOSE 3000

# # Start the app
# CMD ["npm", "start"]

FROM node:16-alpine

ADD . /app

WORKDIR /app

RUN npm install

ENTRYPOINT [ "npm" ]

CMD [ "start" ]



