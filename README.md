# Litmus AI — On-Prem Setup

Self-host the Litmus AI dashboard and API server on your own machine using Docker.

## Prerequisites

- [Docker Desktop](https://docs.docker.com/get-docker/) (includes Docker Compose v2)
- An [OpenAI API key](https://platform.openai.com/api-keys)

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/litmusai/litmus-setup.git
cd litmus-setup

# 2. Run setup (creates .env with your API key)
bash setup.sh

# 3. Start
bash start.sh
```

The dashboard will be available at **http://localhost:3000** and the API at **http://localhost:8000**.

## Commands

| Script | Description |
|--------|-------------|
| `./setup.sh` | Interactive setup — creates your `.env` file |
| `./start.sh` | Pull latest images and start all services |
| `./stop.sh` | Stop all services |
| `./update.sh` | Pull new image versions and restart |

## Configuration

Edit `.env` to customise ports and data directory:

```env
OPENAI_API_KEY=sk-...
API_PORT=8000          # FastAPI backend port
DASHBOARD_PORT=3000    # Dashboard port
LITMUS_DATA_DIR=./data # Where litmus.db and chroma/ are stored
```

## Data Persistence

All data (SQLite database + ChromaDB vectors) is stored in `./data/` on your host machine. This directory is mounted into the containers and survives restarts and updates.

## Updating

```bash
bash update.sh
```

This pulls the latest `litmusai/litmus-backend:latest` and `litmusai/litmus-frontend:latest` images from DockerHub and restarts the services.
