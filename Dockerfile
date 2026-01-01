# Use Node.js LTS (Long Term Support) version
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build the TypeScript code
RUN npm run build

# Set environment variables (these will be overridden by docker-compose or docker run)
ENV BINANCE_API_KEY=""
ENV BINANCE_API_SECRET=""
ENV NODE_ENV=production

# Expose the port if your MCP server uses one (adjust if needed)
# Note: MCP servers typically use stdio, so this may not be necessary
# EXPOSE 3000

# Run the server
CMD ["node", "build/index.js"]