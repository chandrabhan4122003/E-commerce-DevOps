FROM nginx:alpine

# Copy the static site into the Nginx web root
COPY . /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Optional healthcheck to ensure Nginx is responding
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s CMD wget -qO- http://localhost/ || exit 1

# Nginx will start via the default CMD in the base image

