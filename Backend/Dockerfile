# Use lightweight Node image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of files
COPY . .

# Expose dynamic port (will be defined in compose)
EXPOSE 5000

# Start service
CMD ["node", "server.js"]