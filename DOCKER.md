# ComfyUI Docker Image

This repository includes automated Docker image builds that are released weekly.

## Automated Builds

A Docker image is automatically built and published to GitHub Container Registry (ghcr.io) every Monday at 00:00 UTC via GitHub Actions workflow.

## Using the Docker Image

### Pull the latest image

```bash
docker pull ghcr.io/synapticore-studio/comfyui:latest
```

### Pull a specific version

```bash
docker pull ghcr.io/synapticore-studio/comfyui:0.13.0
```

### Run ComfyUI in a container

```bash
docker run -d \
  --name comfyui \
  -p 8188:8188 \
  -v $(pwd)/models:/app/models \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  ghcr.io/synapticore-studio/comfyui:latest
```

Access ComfyUI at: http://localhost:8188

### Run with GPU support (NVIDIA)

For GPU support, you need nvidia-docker:

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v $(pwd)/models:/app/models \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  ghcr.io/synapticore-studio/comfyui:latest
```

## Building Locally

If you want to build the Docker image locally:

```bash
docker build -t comfyui:local .
```

## Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  comfyui:
    image: ghcr.io/synapticore-studio/comfyui:latest
    ports:
      - "8188:8188"
    volumes:
      - ./models:/app/models
      - ./input:/app/input
      - ./output:/app/output
      - ./custom_nodes:/app/custom_nodes
    environment:
      - PYTHONUNBUFFERED=1
    # Uncomment for GPU support
    # deploy:
    #   resources:
    #     reservations:
    #       devices:
    #         - driver: nvidia
    #           count: all
    #           capabilities: [gpu]
```

Run with:

```bash
docker-compose up -d
```

## Volumes

The Docker image uses the following directories:

- `/app/models` - Store your AI models here
- `/app/input` - Input files for processing
- `/app/output` - Generated output files
- `/app/custom_nodes` - Custom nodes directory

Mount these directories as volumes to persist data between container restarts.

## Configuration

The default command runs ComfyUI with:
- Listen on all interfaces (`--listen 0.0.0.0`)
- Port 8188 (`--port 8188`)

You can override this by providing your own command:

```bash
docker run -p 8188:8188 ghcr.io/synapticore-studio/comfyui:latest \
  python main.py --listen 0.0.0.0 --port 8188 --cpu
```

## Manual Workflow Trigger

The Docker build workflow can also be triggered manually:

1. Go to Actions tab in GitHub
2. Select "Weekly Docker Image Release"
3. Click "Run workflow"

## Image Tags

- `latest` - The most recent build
- `<version>` - Specific version (e.g., `0.13.0`)
- `<version>-<sha>` - Version with git commit SHA

## Notes

- Models are not included in the Docker image and need to be downloaded separately
- The image is optimized for CPU execution by default
- For GPU support, ensure you have the appropriate NVIDIA drivers and nvidia-docker installed
