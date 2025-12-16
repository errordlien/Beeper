# Build Stage
FROM golang:1.25-bookworm AS builder

WORKDIR /app

# Clone the repository
# We clone specifically to ensure we get the build scripts and versioning info correctly
# Synced with beeper/bridge-manager (updated automatically)
RUN git clone https://github.com/beeper/bridge-manager.git .

# Build the bbctl binary
RUN chmod +x build.sh && ./build.sh

# Runtime Stage
FROM debian:bookworm-slim

# Install dependencies required by various bridges
# - ffmpeg: Required for media conversion in some bridges (e.g., WhatsApp, Signal)
# - python3 & python3-venv: Required for Python-based bridges
# - ca-certificates: Required for HTTPS connections
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-venv \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the built binary from the builder stage
COPY --from=builder /app/bbctl /usr/local/bin/bbctl

# Create standard configuration and data directories
RUN mkdir -p /root/.config /root/.local/share/bbctl

# Expose these directories as volumes for persistence
VOLUME ["/root/.config", "/root/.local/share/bbctl"]

# Set the entrypoint to the bridge manager tool
ENTRYPOINT ["bbctl"]

# Default command displays help
CMD ["--help"]