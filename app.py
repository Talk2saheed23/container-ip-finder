# app.py
import requests
import subprocess
import os
from flask import Flask, render_template_string

# Define the version of the application
VERSION = "1.0.0"

# Create a Flask app
app = Flask(__name__)

def get_public_ip():
    """Fetches the public IP address from an external service."""
    try:
        response = requests.get('https://api.ipify.org?format=json')
        ip_data = response.json()
        return ip_data['ip']
    except Exception as e:
        return f"Error fetching public IP: {e}"

def get_internal_ip():
    """Fetches the container's internal IP address using a bash command."""
    try:
        # Running bash command to get the internal IP address
        result = subprocess.run(
            ["hostname", "-I"], capture_output=True, text=True, check=True
        )
        # hostname -I returns all IPs, we take the first one which is usually the internal IP
        internal_ip = result.stdout.split()[0]
        return internal_ip
    except Exception as e:
        return f"Error fetching internal IP: {e}"

def get_container_image_id():
    """Fetches the container image ID by inspecting the Docker container."""
    try:
        # Get the container ID from environment variable
        container_id = os.getenv('HOSTNAME', 'Unknown')
        # Run `docker inspect` command to get the image ID
        result = subprocess.run(
            ["docker", "inspect", "--format='{{.Image}}'", container_id],
            capture_output=True, text=True, check=True
        )
        image_id = result.stdout.strip().strip("'")
        return image_id
    except Exception as e:
        return f"Error fetching container image ID: {e}"

def get_image_os_version():
    """Fetches the OS version from /etc/os-release."""
    try:
        result = subprocess.run(
            ["grep", "VERSION_ID", "/etc/os-release"], capture_output=True, text=True, check=True
        )
        image_os_version = result.stdout.split('=')[1].strip().strip('"')
        return image_os_version
    except Exception as e:
        return f"Error fetching OS version: {e}"

@app.route('/')
def index():
    public_ip = get_public_ip()
    internal_ip = get_internal_ip()
    image_os_version = get_image_os_version()
    
    html_template = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>IP Fetcher</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            h1 { color: #333; }
            p { font-size: 1.2em; }
        </style>
    </head>
    <body>
        <h1>Application Information</h1>
        <p><strong>Application Version:</strong> {{ version }}</p>
        <p><strong>Public IPv4 Address:</strong> {{ public_ip }}</p>
        <p><strong>Container Internal IPv4 Address:</strong> {{ internal_ip }}</p>
        <p><strong>OS Version:</strong> {{ image_os_version }}</p>
    </body>
    </html>
    """
    return render_template_string(html_template, version=VERSION, public_ip=public_ip, internal_ip=internal_ip, image_os_version=image_os_version)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
