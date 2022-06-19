#!/bin/bash
set -e
source .env-dev

ORIGPWD=$(pwd)
CLIENT_DIR="${SRC_DIR}/atomic-fishbowl-client"
SERVER_DIR="${SRC_DIR}/atomic-fishbowl-server"
CLIENT_REPO="https://github.com/KensingtonTech/atomic-fishbowl-client.git"
SERVER_REPO="https://github.com/KensingtonTech/atomic-fishbowl-server.git"

create_src_dir () {
  echo "The source directory was not found, as defined by .env-dev :"
  echo -e "SRC_DIR: ${SRC_DIR}\n"
  local res
  read -p 'Would you like me to create it? (y/N): ' res
  res=${res:-N}
  res=$(echo $res | awk '{print tolower($0)}')
  if [[ $res = "y" || $res = "yes" ]]; then
    mkdir -p "${SRC_DIR}"
  else
    exit 1
  fi
}

create_conf_dir () {
  echo "The configuration directory was not found, as defined by .env-dev :"
  echo -e "CONF_DIR: ${CONF_DIR}\n"
  local res
  read -p 'Would you like me to create it? (y/N): ' res
  res=${res:-N}
  res=$(echo $res | awk '{print tolower($0)}')
  if [[ $res = "y" || $res = "yes" ]]; then
    mkdir -p "${CONF_DIR}"/certificates
  else
    exit 1
  fi
}

create_data_dir () {
  echo "The data directory was not found, as defined by .env-dev :"
  echo -e "DATA_DIR: ${DATA_DIR}\n"
  local res
  read -p 'Would you like me to create it? (y/N): ' res
  res=${res:-N}
  res=$(echo $res | awk '{print tolower($0)}')
  if [[ $res = "y" || $res = "yes" ]]; then
    mkdir -p "${DATA_DIR}"/collections
    mkdir -p "${DATA_DIR}"/server
  else
    exit 1
  fi
}

if [ ! -e "${SRC_DIR}"  ]; then
  create_src_dir
fi

if [ ! -e "${CONF_DIR}" ]; then
  create_conf_dir
fi

if [ ! -e "${DATA_DIR}"  ]; then
  create_data_dir
fi

if [ ! -e "${CLIENT_DIR}"  ]; then
  echo "Cloning client to ${CLIENT_DIR}"
  cd "${SRC_DIR}"
  git clone "${CLIENT_REPO}"
fi

if [ ! -e "${SERVER_DIR}"  ]; then
  echo "Cloning server to ${SERVER_DIR}"
  cd "${SRC_DIR}"
  git clone "${SERVER_REPO}"
fi

# Test for Docker compose v2
set +e
docker compose &>/dev/null
if [ $? -ne 0 ]; then
  echo "Docker compose v2 is not installed.  Please ensure your Docker installation is up-to-date, and that docker-compose-plugin is installed"
  exit 1
fi

set -e
cd $ORIGPWD
docker compose --env-file .env-dev -f docker-compose-dev.yml up -d