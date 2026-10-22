# MultiContainer Wordpress Setup
A multicontainer setup to demonstrate usage of docker compose to handle multiple containers. In this example, a Wordpress container and  a DB container is configured.
This repository provides a reproducible, self contained way to deploy Wordpress without needing to install PHP, Apache or MySQL directly on the host machine. Both services run in containers, their data persists across restarts and it can all be setup or stopped with a single command.

## Table of Contents

- [MultiContainer Wordpress Setup](#multicontainer-wordpress-setup)
- [Prerequisites](#prerequisites)
- [Quickstart](#quickstart)
- [Project Structure](#project-structure)
- [Usage](#usage)
  - [Steps and Configuration](#steps-and-configuration)
  - [Modifying Behavior](#modifying-behavior)
    - [Change the WordPress version](#change-the-wordpress-version)
    - [Change the MySQL version](#change-the-mysql-version)
    - [Raise the PHP upload limit](#raise-the-php-upload-limit)
    - [Enable debug mode](#enable-debug-mode)
    - [Change the table prefix](#change-the-table-prefix)
    - [Reset everything](#reset-everything)

## Prerequisites

Docker engine and Docker compose must be installed on the host.

## Quickstart

1. Create .env file

```bash
cp example.env .env 
```

2. Setup your user name and password for both worpress and the mysql db. Make sure they match.

3. Start the services:

```bash
docker compose up -d
```

4. Verify the containers are running:

```bash
docker ps
```

5. Your wordpress will now be reachable under: <CLOUD_VM_IP>:<SERVER_PORT> and you can complete the Wordpress instalation.

## Project Structure

- ".docs" : Contains any relevant documents (Project checklist).
- "gitignore" : Prevents irrelevant files from being commited.
- "docker-compose-yaml" : A configuration file for Docker to define the necessary services such as wordpress image, mysql db image, port mapping, volumes, etc.
- "example.env" : Contains example environment variables to setup the project such as database cedentials and non critical configuration values kept out of the Compose file.
- "README.md" : This document. Contains insructions on how to setup and deploy the containers (Wordpress and DB).

## Usage

There are two services declared: wordpress and db, wordpress depends on db so Compose starts the db first. Both services join the same user-defined network, which allows wordpress to reach the database by the hostname db instead of an IP address.

### Steps and Configuration

1. Clone the repository.
2. Copy the environment variables and setup up your username and password for both wordpress and the mysql db. The credentials must match to avoid an "Error establishing a database connection" as the database creates the user and wordpress then authenticates with it.

```bash
cp example.env .env 
```

3. Start the services by running the following command:

```bash
docker compose up -d
```

4. To check if it started correctly use the following command:

```bash
docker compose ps
```

5. Access wordpress through <localhost>:<8080>

### Modifying Behavior

- #### Change the WordPress version

    edit the image tag in docker-compose.yml, e.g. wordpress:6.7-php8.3-apache, then run docker compose up -d.

- #### Change the MySQL version

    edit image: mysql:8.4 to another tag. Note that downgrading a major version against an existing volume can corrupt data — back up first.

- #### Raise the PHP upload limit

    add a Dockerfile that extends the official image and set build: . in place of image::

```bash
FROM wordpress:6-php8.3-apache
RUN echo "upload_max_filesize = 64M" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/uploads.ini
Copy
```

- #### Enable debug mode

    set WORDPRESS_DEBUG=1 in the Compose file's environment block, then restart.

- #### Change the table prefix

    set WORDPRESS_TABLE_PREFIX before the first start. Changing it later requires migrating the existing tables manually.

- #### Reset everything

    docker compose down -v removes the containers and both volumes, giving you a clean install. This deletes all site data — use it only when you intend to start over.
