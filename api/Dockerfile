# Use official Node.js runtime as base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Try npm ci first, fallback to npm install if package-lock.json doesn't exist
RUN npm ci --only=production || npm install --production

# Copy source code
COPY src/ ./src/

# Create healthcheck file
RUN echo "const http = require('http'); const options = { host: '0.0.0.0', port: 3000, path: '/health', timeout: 2000 }; const request = http.request(options, (res) => { process.exit(res.statusCode === 200 ? 0 : 1); }); request.on('error', () => { process.exit(1); }); request.end();" > healthcheck.js

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && adduser -S nodeuser -u 1001

# Change ownership of app directory
RUN chown -R nodeuser:nodejs /app
USER nodeuser

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

# Start application
CMD ["npm", "start"]
