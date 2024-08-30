# Container IP Finder

Container IP Finder is a Docker-based tool that creates a simple web page displaying information about the container and its host. This project is useful for understanding container networking, debugging deployment issues, or simply as a learning tool for Docker and container concepts.

## Features

There are two setups in this repo, Bash and python implementation

### Bash Setup
This contains the script.sh and Dockerfile.ubuntu. It uses bash script command configuration to fetch information about the container, package it into an Html file and serve the html with python server. 

- Displays the container's IPv4 address
- Shows the host machine's IPv4 address (Docker network interface)
- Indicates the base image used for the container

### Python setup
This contains the app.py and the Dockerfile. this is the setup implemented by the github CICD workflow and will build a simple python html page that;
  
- Displays the container's IPv4 address
- Shows the host machine's IPv4 address (Docker network interface)
- Provides the container's Alpine Linux version
- Indicates the base image used for the container

## Prerequisites

To use this project via the CICD to deploy the container directly to Azure AKS, set the following secrets in you github repo after cloning this one;

- DOCKERHUB_USERNAME: your dockerhub username
- DOCKERHUB_TOKEN   : generate a token with read and write access
- AZURE_CREDENTIALS : generate azure credentials
  
To get azure credentials, intall azure cli and run

```
az login
az account show --query id -o tsv #to get your sub-ID
az ad sp create-for-rbac --name "myApp" --role contributor --scopes /sub-ID --sdk-auth
```
create a dockerhub repository for the container image with the name used in the workflow(container-ip-finder). Then rerun the workflow.

NB: ensure you edit the container image name in your terraform variable file as well

To use this project manually, you need to have the following installed on your system:

- Docker

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/container-ip-finder.git
   cd container-ip-finder
   ```

2. Build the Docker image:
   ```
   docker build -t container-ip-finder .
   ```

## Usage

To run the container:

```
docker run -d -p 8080:5000 container-ip-finder
```

Then, open a web browser and navigate to `http://localhost:8080`. You should see a page displaying the container and host information.

## How the Bash setup Works

1. The Dockerfile sets up an Nginx server with Alpine Linux as the base image.
2. A bash script (`script.sh`) is copied into the container and executed during the build process.
3. The script gathers information about the container and its environment, then generates an HTML file.
4. Nginx serves this HTML file, making it accessible when you connect to the container.

## File Structure

- `Dockerfile`: Defines how to build the Docker image
- `script.sh`: Bash script that collects system information and generates the HTML
- `README.md`: This file, containing project documentation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Thanks to the Docker and Nginx teams for their excellent tools
- Inspired by the need for simple container debugging tools

---
