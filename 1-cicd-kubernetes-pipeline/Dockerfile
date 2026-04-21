# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copy dependency files first (better layer caching)
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY . .

# Stage 2: Production image (smaller final image)
FROM node:18-alpine

WORKDIR /app

# Create non-root user for security (DevSecOps best practice)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only what's needed from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app .

# Set ownership
RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
