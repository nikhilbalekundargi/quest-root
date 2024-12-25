# Use the official Node.js image as the base image
# Use a specific version for consistency and security
FROM node:14-alpine

# Create and set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
# This allows Docker to cache the npm install step if package.json hasn't changed
COPY package*.json ./

# Install the dependencies
# Use --only=production to reduce the image size by only installing production dependencies
RUN npm install --only=production

# Copy the rest of the application code to the working directory
COPY . .

# Create a non-root user and switch to that user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the application
CMD ["npm", "start"]