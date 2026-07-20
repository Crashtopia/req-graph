# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache python3 make g++ git

# Copy everything
COPY . .

# Install dependencies
RUN npm install

# Build the editor client
RUN npm run build

# Runtime stage
FROM node:18-alpine

WORKDIR /app

RUN apk add --no-cache python3

# Copy everything from builder
COPY --from=builder /app .

EXPOSE 1880

CMD ["node", "packages/node_modules/node-red/red.js", "--settings", "packages/node_modules/node-red/settings.js"]