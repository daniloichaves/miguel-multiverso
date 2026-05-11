# Build stage: Copy files only
FROM nginx:1.27-alpine AS builder
WORKDIR /app
COPY . .

# Production stage: minimal Alpine with security hardening
FROM nginx:1.27-alpine

# Remove unnecessary packages and tools to reduce attack surface
RUN apk del apk-tools curl \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Copy only site files from builder
COPY --from=builder /app /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]