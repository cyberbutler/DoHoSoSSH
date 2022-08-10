#!/usr/bin/dumb-init /bin/sh

# Launch AutoSSH Tunnel
if [ -z ${AUTOSSH_REMOTE_USER} ]; then
    echo "[-] No AUTOSSH_REMOTE_USER specified";
    exit;
fi;

if [ -z ${AUTOSSH_REMOTE_HOST} ]; then
    echo "[-] No AUTOSSH_REMOTE_HOST specified";
    exit;
fi;

if [ ! -f ${AUTOSSH_PRIVATE_KEYFILE:=/tunnel/private.key} ]; then
    echo "[-] You must specify a AUTOSSH_PRIVATE_KEYFILE and mount it as a volume to use this container.";
    exit;
fi;

autossh \
    -M ${AUTOSSH_MONITOR_PORT:=0} \
    ${AUTOSSH_OPTIONS:=-N -o "StrictHostKeyChecking=no"} \
    ${AUTOSSH_TUNNEL:=-D 0.0.0.0:8080} \
    -i ${AUTOSSH_PRIVATE_KEYFILE:=/tunnel/private.key} \
    -p ${AUTOSSH_REMOTE_PORT:=22} \
    ${AUTOSSH_REMOTE_USER}@${AUTOSSH_REMOTE_HOST} &

# Hacky, but sleep for a second to ensure autossh doesn't error out
sleep 1

if ! (pgrep autossh); then
    exit;
fi;

if [ ! -z ${DOH_UPSTREAM_SERVERS} ]; then
    upstream_args="--upstream $(echo ${DOH_UPSTREAM_SERVERS} | sed 's/,/ --upstream /g')";
fi;

cloudflared proxy-dns $upstream_args --address 0.0.0.0