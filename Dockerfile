
# Use Python 3.12 as the base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY app.py .
COPY test_app.py .

# Expose application port
EXPOSE 5000

# Start Flask application
CMD ["python", "app.py"]
