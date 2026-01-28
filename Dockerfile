# ---------- Build stage ----------
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy go module file and download deps
COPY go.mod ./
RUN go mod download

# Copy source code
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

# ---------- Runtime stage ----------
FROM alpine:latest

WORKDIR /app

# Copy binary from builder stage
COPY --from=builder /app/app .

# Expose application port
EXPOSE 9090

# Run the app
CMD ["./app"]
