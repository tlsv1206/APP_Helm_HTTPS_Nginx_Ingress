# app.py
# This is a simple Flask application that returns a greeting message.
# It is intended to be run in a Kubernetes environment, specifically in an EKS production setup
from flask import Flask                                         # This line imports the Flask class from the flask module
app = Flask(__name__)                                           # This line creates an instance of the Flask class, which is our WSGI application

@app.route('/')                                                 # This line defines a route for the root URL of the application
def hello():                                                    # This function will be called when the root URL is accessed
    return "Hello, World from Kubernetes EKS Production!"       # This line returns a greeting message when the root URL is accessed

if __name__ == '__main__':                                      # This line checks if the script is being run directly (not imported as a module)
                                                                # If the script is run directly, the Flask application will start
                                                                # The application will listen on all available IP addresses (
    app.run(host='0.0.0.0', port=5000)                          # This line starts the Flask application on port 5000