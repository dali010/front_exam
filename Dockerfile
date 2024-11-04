# Step 1: Build Stage
FROM node:18 AS build
 
# Set the working directory
WORKDIR /app
 
# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json  ./
 
# Install dependencies
RUN npm ci
 
 
# Copy the rest of the application code
COPY . .
 
ENV NODE_ENV=production
# Build the application
RUN npm run build --debug
 
# Step 2: Runtime Stage
FROM nginx:alpine
 
# Copy the built application from the build stage
COPY --from=build /app/build /usr/share/nginx/html
 
 
# Copy custom nginx configuration if needed
COPY --from=build /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf
 
# Expose port 80 for nginx
EXPOSE 80
 
# Start nginx
CMD ["nginx", "-g", "daemon off;"]