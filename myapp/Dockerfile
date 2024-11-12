# Use an appropriate base image
FROM python:3.8-slim

# Set working directory
WORKDIR /app

# Copy application code
COPY app_code/ /app

# Install dependencies
RUN pip install -r requirements.txt

##S Specify the command to run the app
CMD ["python", "app.py"]
