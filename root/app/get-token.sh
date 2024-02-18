#!/bin/bash
# shellcheck shell=bash

read -r -p "Enter Token Description: " plex_product
read -r -p "Enter Username: " plex_username
read -r -p "Enter Password: " plex_password
read -r -p "Enter 2FA Code: " plex_2facode

plex_token=$(curl -fsSL -u "${plex_username}":"${plex_password}${plex_2facode}" 'https://plex.tv/users/sign_in.json' -X POST \
    -H "X-Plex-Client-Identifier: $(cat /proc/sys/kernel/random/uuid)" \
    -H "X-Plex-Product: ${plex_product}" \
    -H "X-Plex-Version: $(date -u +'%Y%m%d%H%M%S')" \
    -H "X-Plex-Provides: controller" \
    -H "X-Plex-Device: $(uname -s) $(uname -r)" \
    | jq -re '.[].authentication_token')

echo "Your Plex Token: ${plex_token}"
