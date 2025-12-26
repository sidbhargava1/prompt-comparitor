# Dockerfile
# Use a slim Python base image for smaller footprint
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# System deps (add ca-certificates + curl for health/debug, tzdata for logs)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl tzdata \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY prompt_comparator_gpt.py .

# Non-root user for security
RUN useradd -m appuser
USER appuser

# Default environment (do NOT bake secrets)
ENV PYTHONUNBUFFERED=1

# Entrypoint runs the module's demo; override in compose to pass custom prompts
ENTRYPOINT ["python", "prompt_comparator_gpt.py"]
