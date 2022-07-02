# Atomic Fishbowl Docker

This repo contains Docker Compose definitions for Atomic Fishbowl.  That means you can stand up a production and/or development environment for Atomic Fishbowl.

Docker images can be found at:

* [Server Image](https://hub.docker.com/repository/docker/kensingtontech/atomic-fishbowl-server)
* [Client Nginx Image](https://hub.docker.com/repository/docker/kensingtontech/atomic-fishbowl-nginx)

## Prerequisites

* Docker with Compose v2
* A functioning NetWitness installation with a Packet Decoder

## Production Environment

A production environment uses a Docker volume to store its data, and is comprised of three containers:

* Server
* Nginx
* Database

### To stand up a production environment:
```
./up.sh
```

Bring it down with:
```
./down.sh
```

### Login
The default login credentials are `admin` / `kentech0`


## Atomic Fishbowl Repositories
* [Atomic Fishbowl Project Home](https://github.com/KensingtonTech/atomic-fishbowl)
* [Atomic Fishbowl Server](https://github.com/KensingtonTech/atomic-fishbowl-server)
* [Atomic Fishbowl Client](https://github.com/KensingtonTech/atomic-fishbowl-client)

## Environment Variables
The following environment variables can be set in files `.env` or `.env-dev`:
* `LOG_LEVEL` - `info`, `warn`, `error`, `debug`.  Affects the back-end only.
* `SSL_CERT_HOSTNAME` - The server will generate a self-signed SSL certificate on its first run.  This is the certificate's subject / hostname.  Ideally use an FQDN.
* `SSL_CERT_ALT_HOSTNAME`.  Controls the Subject Alternate Name (SAN) of the SSL certificate.


## Development Environment

For your convenience, a containerised development environment is provided, intended for use with VS Code.  It is comprised of four containers

* Server
* Client
* Nginx
* Database

### To stand up the development environment:
```
./up-dev.sh
```

Bring it down with:
```
./down-dev.sh
```

The script will prompt you to create any missing directories.

In our dev environment, the source code lives on the host filesystem, and is mapped into the containers by Docker compose.  The script will automatically download the appropriate Github repos using git if they do not already exist.

Note that the entire source code dir is mapped into each container, which defaults to `$HOME/src`.

The dev environment uses the host local filesystem for AFB's certificates and data.

The locations, from `.env-dev` are:
```
CONF_DIR=$HOME/afb/etc
DATA_DIR=$HOME/afb/var
```

#### TOP TIP
Dev container names will by default be prefixed with `afb-dev`.  This is controlled by `COMPOSE_PROJECT_NAME` in `.env-dev`.

### Development Environment VS Code Config

In VS Code, using the `Remote - Containers` and / or the `Remote - SSH` extensions, choose `Remote Containers: Attach to Running Container` from the command palette.

The first time you attach to the containers, the VS code workspace will be opened in the wrong location, and with the wrong user.  Configure the workspaces by opening the Command Palette, and choosing `Open Container Configuration File`.  We suggest the following defaults:

Server:
```
{
	"workspaceFolder": "/home/node/src/atomic-fishbowl-server",
	"remoteUser": "node",
	"extensions": [
		"dbaeumer.vscode-eslint",
		"quicktype.quicktype"
	]
}
```

Client:
```
{
	"workspaceFolder": "/home/node/src/atomic-fishbowl-client",
	"remoteUser": "node",
	"extensions": [
		"dbaeumer.vscode-eslint"
	]
}
```

Save the config files, close the container windows, and finally reattach to them.

The dev client and server processes do not start automatically -- you must run the manually from the within the containers.  Start both client and server with `npm start`.

The default development env HTTPS port is `444`.

#### TOP TIP
You may first have to run `npm install` from within each container before they will start.

## Issues
For issue with the dev or prod Docker compose stack, file an issue in this project.  For issues with the client or server, file an issue in the appropriate project.  See the links above.