#!/usr/bin/env bash

export TIME_ZONE="Europe/Helsinki"
export KALTURA_FULL_VIRTUAL_HOST_NAME="dockerhost:$KALTURA_CONTAINER_PORT"
export KALTURA_VIRTUAL_HOST_NAME="dockerhost"
export KALTURA_VIRTUAL_HOST_PORT="$KALTURA_CONTAINER_PORT"
export DB1_HOST="127.0.0.1"
export DB1_PORT="3306"
export DB1_PASS="kaltura"
export DB1_NAME="kaltura"
export DB1_USER="kaltura"
export SERVICE_URL="dockerhost:$KALTURA_CONTAINER_PORT"
export SPHINX_SERVER1="127.0.0.1"
export SPHINX_SERVER2="127.0.0.1"
export DWH_HOST="127.0.0.1"
export DWH_PORT="3306"
export ADMIN_CONSOLE_ADMIN_MAIL="yle_local_dev@noreply.yle.fi"
export ADMIN_CONSOLE_PASSWORD="DEV@yle.fi"
export CDN_HOST="dockerhost:$KALTURA_CONTAINER_PORT"
export SUPER_USER="root"
export SUPER_USER_PASSWD="root"
export ENVIRONMENT_NAME="Yle Dev"
export DWH_PASS="kaltura"
export PROTOCOL="http"
export RED5_HOST="127.0.0.1"
export USER_CONSENT="0"
export CONTACT_MAIL="NO"
export VOD_PACKAGER_HOST="127.0.0.1"
export VOD_PACKAGER_PORT="88"
export IP_RANGE="0.0.0.0-255.255.255.255"
export WWW_HOST="dockerhost:$KALTURA_CONTAINER_PORT"
export CONFIG_CHOICE="0"
export IS_SSL="n"
export IS_NGINX_SSL="n"