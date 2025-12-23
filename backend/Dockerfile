# Stage 1: Build
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim
RUN useradd -m appuser
WORKDIR /app
COPY --from=builder /usr/local/lib /usr/local/lib
COPY app.py .
USER appuser
EXPOSE 5000
CMD ["python", "app.py"]
