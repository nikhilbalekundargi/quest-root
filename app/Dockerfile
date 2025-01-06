FROM node:${NODE_VERSION} as build

# Set the working directory
WORKDIR /usr/src/app

# Update packages and install security patches
RUN apk update && apk upgrade && \
    apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -S nodejs -g 1001 && \
    adduser -S nodejs -G nodejs -u 1001 && \
    chown -R nodejs:nodejs /usr/src/app

# Switch to non-root user
USER nodejs

# Copy package files with correct ownership
COPY --chown=nodejs:nodejs package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY --chown=nodejs:nodejs . .

# Build stage
FROM node:${NODE_VERSION}-alpine

WORKDIR /usr/src/app

# Update packages and install security patches
RUN apk update && apk upgrade && \
    apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -S nodejs -g 1001 && \
    adduser -S nodejs -G nodejs -u 1001 && \
    chown -R nodejs:nodejs /usr/src/app

# Switch to non-root user
USER nodejs

# Copy built app with correct ownership
COPY --from=build --chown=nodejs:nodejs /usr/src/app .

# Expose port
EXPOSE 3000

# Start application
CMD ["npm", "start"]