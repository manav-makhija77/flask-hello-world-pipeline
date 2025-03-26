# Use the official Python image as a base
FROM python:3.8-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .

# Install dependencies (including Gunicorn)
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Flask app into the container
COPY . .

# Expose the port the app will run on
EXPOSE 5000

# Set the entrypoint to run the Gunicorn server
CMD ["gunicorn", "-b", "0.0.0.0:5000", "main:app"]

