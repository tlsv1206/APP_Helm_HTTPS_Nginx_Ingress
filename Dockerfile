# Dockerfile
# This Dockerfile is used to build a simple Flask application container.
# It sets up the working directory, installs Flask, exposes port 5000, and runs the application.
# It is designed to be used in a Kubernetes environment.
# It is a minimal setup to demonstrate how to containerize a Python Flask application.

 # Use a lightweight Python image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app                                    

# Copy the application code into the container
COPY app.py .

# Install Flask
# This is the only dependency for this simple Flask application.
# In a real application, you might have a requirements.txt file to manage dependencies.
RUN pip install flask

# Expose port 5000 for the Flask application
# This is the default port for Flask applications.
# It allows the application to be accessible from outside the container.
EXPOSE 5000

# Command to run the Flask application
# This command starts the Flask application when the container is run.
CMD ["python", "app.py"]