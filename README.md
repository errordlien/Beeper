# Beeper Bridge Manager Docker Container

A containerized version of [Beeper's bridge-manager](https://github.com/beeper/bridge-manager) (`bbctl`) for managing Matrix bridges.

## Overview

This Docker container packages the Beeper bridge manager tool with all necessary dependencies to run various Matrix bridges (WhatsApp, Signal, Discord, etc.) in a containerized environment.

## Features

- Built on Debian Bookworm Slim for minimal footprint
- Includes all required dependencies:
  - FFmpeg for media conversion (WhatsApp, Signal bridges)
  - Python 3 with virtual environment support for Python-based bridges
  - CA certificates for secure HTTPS connections
- Persistent volumes for configuration and data
- Multi-stage build for optimized image size

## Usage

### Basic Usage

Run the container with the default help command:

```bash
docker run --rm errordlien/beeper
```

### Running with Persistent Storage

Mount volumes to persist configuration and bridge data:

```bash
docker run --rm \
  -v beeper-config:/root/.config \
  -v beeper-data:/root/.local/share/bbctl \
  errordlien/beeper [command]
```

### Common Commands

```bash

# Connect to Beeper
docker run --rm \
  -v beeper-config:/root/.config \
  -v beeper-data:/root/.local/share/bbctl \
  errordlien/beeper login

# Run a bridge (e.g. WhatsApp)
docker run -d \
  --name beeper-whatsapp \
  -v beeper-config:/root/.config \
  -v beeper-data:/root/.local/share/bbctl \
  errordlien/beeper run sh-whatsapp

# Run a Signal bridge
docker run -d \
  --name beeper-signal \
  -v beeper-config:/root/.config \
  -v beeper-data:/root/.local/share/bbctl \
  errordlien/beeper run sh-signal

```

## Volumes

The container uses two volumes for data persistence:

- `/root/.config` - Configuration files
- `/root/.local/share/bbctl` - Bridge manager data and installed bridges

## Building

Build the image locally:

```bash
docker build -t beeper .
```

## Automated Updates

This repository automatically syncs with upstream [beeper/bridge-manager](https://github.com/beeper/bridge-manager) releases:

- **Automatic Sync**: Checks for new upstream releases every 6 hours
- **Release Creation**: Automatically creates matching releases with upstream release notes
- **Docker Publishing**: Builds and publishes multi-platform Docker images (amd64/arm64)
- **Registry**: Images are published to GitHub Container Registry

### Available Images

```bash
# GitHub Container Registry
docker pull ghcr.io/errordlien/beeper:latest
docker pull ghcr.io/errordlien/beeper:v1.0.0  # specific version
```

### Manual Trigger

You can manually trigger the sync workflow from the Actions tab in GitHub.

## Dependencies

The container includes:

- Golang 1.25 (build stage only)
- Debian Bookworm Slim (runtime)
- FFmpeg
- Python 3 with venv
- CA certificates

## License

This project packages the [Beeper bridge-manager](https://github.com/beeper/bridge-manager). Please refer to the upstream repository for licensing information.
