# Project Overview

This repository contains the configuration and custom tools for a personal home server (homelab) managed with Docker Compose. It uses a centralized Traefik reverse proxy with a custom forward authentication service to secure various self-hosted applications.

## Main Components

- **Traefik**: Acts as the main entry point (reverse proxy) for all services, handling SSL termination (via ACME/Let's Encrypt) and routing.
- **Custom Login App (`apps/login`)**: A lightweight authentication service built with [ElysiaJS](https://elysiajs.com/) and [Bun](https://bun.sh/). It provides a simple password-based login and integrates with Traefik's `forwardauth` middleware to protect services.
- **Media Stack**: Includes Sonarr, Radarr, Readarr, Prowlarr, Transmission, Plex, and Jellyfin for media management and streaming.
- **Development Tools**: 
  - **Forgejo**: Self-hosted git service.
  - **Convex**: Local instance of the Convex backend and dashboard.
  - **n8n**: Workflow automation tool.
  - **Dev Container**: An OpenSSH server for remote development.
- **Infrastructure & Utilities**:
  - **Wireguard (wg-easy)**: VPN for secure remote access.
  - **Heimdall**: Application dashboard/homepage.
  - **Samba**: Network file sharing.
  - **netboot.xyz**: Network boot server.
  - **Immich**: High-performance self-hosted photo and video backup solution (located in `compose/immich`).

## Architecture

Most services are defined in the root `docker-compose.yaml` and share the `dt_default` network. Traefik handles external traffic on ports 80 and 443. Services are typically accessed via subdomains (e.g., `sonarr.example.com`) and are protected by the `login@docker` middleware, which redirects unauthenticated users to the custom login page.

## Building and Running

### Prerequisites
- Docker and Docker Compose installed.
- A `.env` file in the root directory with at least the following variables:
  - `DOMAIN`: Your base domain (e.g., `example.com`).
  - `PASSWORD`: The password for the custom login app.
  - `TZ`: Your timezone (e.g., `Europe/Stockholm`).

### Basic Commands
- **Start all core services**:
  ```bash
  docker compose up -d
  ```
- **Start Immich**:
  ```bash
  cd compose/immich
  docker compose up -d
  ```
- **Rebuild the Login App**:
  ```bash
  docker compose build login
  ```
- **View Logs**:
  ```bash
  docker compose logs -f [service_name]
  ```

## Development Conventions

- **Service Configuration**: Services are defined using YAML anchors (`&service_name`) and aliases (`*service_name`) for a clean and reusable configuration.
- **Forward Auth**: Most web-based services should include the `traefik.http.routers.[name].middlewares: login@docker` label to ensure they are behind the authentication layer.
- **Custom Apps**: New internal tools should be placed in the `apps/` directory with their own `Dockerfile`.
- **External Compose Files**: Large or complex application stacks (like Immich) are kept in the `compose/` directory to keep the main configuration manageable.
