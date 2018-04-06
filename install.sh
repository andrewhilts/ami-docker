#!/bin/bash

echo "Installing the Access My Info development environment."
echo "This may take several minutes."

# Check to see if Docker is installed
if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: Docker is not installed. Please install Docker and re-run this script.' >&2
  exit 1
fi

# Make sure we're in the project root folder.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Get the code for the frontend
git clone https://github.com/andrewhilts/ami frontend/ami-code
cd frontend/ami-code
git checkout webpack

# Set up and configure docker containers
cd $DIR
docker-compose build
docker-compose up -d

# Configure the CMS
docker-compose run --rm setup /home/wp-ami-setup.sh
docker-compose run --rm setup /home/wp-ami-setup.sh

# Set up the frontend config
cp ./frontend/ami-code/app/scripts/modules/config/localConfig.js.default ./frontend/ami-code/app/scripts/modules/config/localConfig.js
docker cp ./frontend/ami-code/app amidocker_frontend_1:/data/

# Output final step to take
echo "Installation almost complete. Log into the CMS at http://localhost:8080/wp-login.php and enable qTranslate-x plugin."
echo "After that, visit http://localhost:3333 to check out the AMI frontend."