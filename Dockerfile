# ComfyUI Docker Image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the application
COPY . .

# Create necessary directories
RUN mkdir -p models/checkpoints models/vae models/loras models/controlnet \
    models/clip models/unet models/upscale_models models/embeddings \
    models/clip_vision models/style_models models/vae_approx \
    input output temp custom_nodes

# Expose the default port
EXPOSE 8188

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV HF_HUB_DISABLE_TELEMETRY=1
ENV DO_NOT_TRACK=1

# Run ComfyUI
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
