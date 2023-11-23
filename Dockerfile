# Stage 1: Build Stage
FROM python:3.11 as builder

WORKDIR /usr/src/app

# Copy application source code
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final Stage
FROM python:3.11-slim

# Create a non-root user and switch to it
RUN useradd -m appuser
USER appuser

WORKDIR /opt/app-root/src

# Copy installed dependencies from builder
COPY --from=builder /usr/local /usr/local

# Ensure scripts in .local are usable:
ENV PATH="/usr/local/bin:$PATH"

# Copy application source with correct permissions
COPY --chown=appuser:appuser . .

EXPOSE 8000

# Run the application
CMD ["uvicorn", "ols:app", "--host", "0.0.0.0"]
