#!/bin/bash

# Get container IPv4 address
CONTAINER_IP=$(hostname -i | awk '{print $1}')

# Get container version (assuming it's stored in /etc/os-release)
CONTAINER_VERSION=$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2)

# Get host machine IPv4 address
HOST_PUBLIC_IP=$(hostname -I | awk '{print $1}')

# Get container base image
BASE_IMAGE=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | tr -d '"')

# Export as environment variables
export CONTAINER_IP
export CONTAINER_VERSION
export HOST_PUBLIC_IP
export BASE_IMAGE

# Create HTML file
cat << EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Container Information</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
        }
        p {
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Container Information</h1>
        <p><strong>Container IP:</strong> $CONTAINER_IP</p>
        <p><strong>Version:</strong> $CONTAINER_VERSION</p>
        <p><strong>Host IP:</strong> $HOST_PUBLIC_IP</p>
        <p><strong>Base Image:</strong> $BASE_IMAGE</p>
    </div>
</body>
</html>
EOF

# Start a simple HTTP server to serve the HTML file
python3 -m http.server 80 --directory /var/www/html