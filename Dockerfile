# Build-Stage
FROM golang:1.24-alpine AS build
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache git

# Copy the source code
COPY . .

# Install templ
RUN go install github.com/a-h/templ/cmd/templ@latest

# Generate templ files
RUN templ generate

# Build the application with static linking
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./main.go

# Deploy-Stage
FROM debian:bookworm-slim
WORKDIR /app

# Install ca-certificates and Deno
RUN apt-get update && apt-get install -y \
    ca-certificates curl unzip && \
    curl -fsSL https://deno.land/x/install/install.sh | sh && \
    mv /root/.deno/bin/deno /usr/local/bin/deno && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variable for runtime
ENV GO_ENV=production

# Copy the statically linked binary from the build stage
COPY --from=build /app/main .

# Ensure binary is executable (optional but safe)
RUN chmod +x ./main

# Expose the port your application runs on
EXPOSE 8090

# Command to run the application
CMD ["./main"]
