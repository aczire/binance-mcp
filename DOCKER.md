## Docker Deployment

### Building the Docker Image

Build the Docker image: 

```sh
docker build -t binance-mcp-server .
```

### Running with Docker

Run the container with environment variables:

```sh
docker run -it \
  -e BINANCE_API_KEY="your_binance_api_key_here" \
  -e BINANCE_API_SECRET="your_binance_api_secret_here" \
  binance-mcp-server
```

### Running with Docker Compose

1. Create a `.env` file in the root directory (if not already created):

```sh
BINANCE_API_KEY=your_binance_api_key_here
BINANCE_API_SECRET=your_binance_api_secret_here
```

2. Start the service:

```sh
docker-compose up -d
```

3. View logs:

```sh
docker-compose logs -f
```

4. Stop the service:

```sh
docker-compose down
```

### Integration with Claude Desktop (Docker Version)

If you want to use the Docker container with Claude Desktop, you'll need to modify the configuration to use Docker: 

```json
{
    "mcpServers": {
        "binance-mcp": {
            "command": "docker",
            "args": [
                "run",
                "-i",
                "--rm",
                "-e", "BINANCE_API_KEY=your_api_key",
                "-e", "BINANCE_API_SECRET=your_api_secret",
                "binance-mcp-server"
            ],
            "disabled": false,
            "autoApprove": []
        }
    }
}
```

### Docker Image Optimization

The Dockerfile uses: 
- **Alpine Linux** for a smaller image size
- **Multi-stage build concept** (can be enhanced further)
- **Production dependencies only** via `npm ci --only=production`
- **.dockerignore** to exclude unnecessary files

For further optimization, you can create a multi-stage build:

```dockerfile
# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/build ./build
ENV NODE_ENV=production
CMD ["node", "build/index.js"]
```