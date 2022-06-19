#!/bin/bash
set -e
source .env-dev

PWD=$(pwd)
CLIENT_DIR="${SRC_DIR}/atomic-fishbowl-client"
SERVER_DIR="${SRC_DIR}/atomic-fishbowl-server"
CLIENT_REPO="https://github.com/KensingtonTech/atomic-fishbowl-client.git"
SERVER_REPO="https://github.com/KensingtonTech/atomic-fishbowl-server.git"

if [ ! -e "${SRC_DIR}"  ]; then
  echo "The base source directory was not found, as defined by .env-dev :"
  echo "SRC_DIR: ${SRC_DIR}"
  echo "\nThis probably shouldn't be the case.  Our default of /usr/local/src should already exist in most Linux environments.  Please create this directory or another suitable source location before continuing."
  echo "Feel free to update .env-dev to configure an alternate location"
  exit 1
fi

create_conf_dir () {
  echo "The configuration directory was not found, as defined by .env-dev :"
  echo "CONF_DIR: ${CONF_DIR}"
  echo "\nWould you like this script to attempt to create it?"
  local res
  read -p 'y/N: ' res
  res=${res:-N}
  res=$(echo $res | awk '{print tolower($0)}')
  if [[ $res = "y" || $res = "yes" ]]; then
    mkdir -p "${CONF_DIR}"
  fi
}

create_data_dir () {
  echo "The data directory was not found, as defined by .env-dev :"
  echo "DATA_DIR: ${DATA_DIR}"
  echo "\nWould you like this script to attempt to create it?"
  local res
  read -p 'y/N: ' res
  res=${res:-N}
  res=$(echo $res | awk '{print tolower($0)}')
  if [[ $res = "y" || $res = "yes" ]]; then
    mkdir -p "${DATA_DIR}"
  fi
}

if [ ! -e "${CONF_DIR}" ]; then
  create_conf_dir
fi

if [ ! -e "${DATA_DIR}"  ]; then
  create_data_dir
fi

if [ ! -e "${CLIENT_DIR}"  ]; then
  echo "Cloning client to ${CLIENT_DIR}"
  cd "${SRC_DIR}" \
  && git clone "${CLIENT_REPO}"
fi

if [ ! -e "${SERVER_DIR}"  ]; then
  echo "Cloning server to ${SERVER_DIR}"
  cd "${SRC_DIR}" \
  && git clone "${SERVER_REPO}"
fi

cd "${PWD}"

# Test for Docker compose v2
set +e
docker compose &>/dev/null
if [ $? -ne 0 ]; then
  echo "Docker compose v2 is not installed.  Please ensure your Docker installation is up-to-date, and that docker-compose-plugin is installed"
  exit 1
fi

set -x
docker compose --env-file .env-dev -f docker-compose-dev.yml up -d