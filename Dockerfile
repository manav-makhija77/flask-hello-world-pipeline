# Use official Python image as base
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy all files from repo to container
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port (Flask runs on 5000 by default)
EXPOSE 5000

# Command to run the app
CMD ["python", "app.py"]
