# Use Node.js LTS (Long Term Support) version
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including devDependencies for building)
RUN npm ci

# Copy source code
COPY . .

# Build the TypeScript code
RUN npm run build

# Remove devDependencies after build to reduce image size
RUN npm prune --production

# Set environment variables (these will be overridden by docker-compose or docker run)
ENV NODE_ENV=production
ENV BINANCE_TESTNET=true

# Expose the port if your MCP server uses one (adjust if needed)
# Note: MCP servers typically use stdio, so this may not be necessary
# EXPOSE 3000

# Run the server
CMD ["node", "build/index.js"]
