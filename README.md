
# DoHoSoSSH
[![](https://img.shields.io/badge/Docker-cyberbutler/dohosossh-2496ED?style=flat-square&logo=Docker)](https://hub.docker.com/repository/docker/cyberbutler/dohosossh)

A **D**NS **o**ver **H**TTP **o**ver **S**OCKS **o**ver **SSH** container for fun and privacy in monitored environments. [Check out the blogpost](#).

# Usage
*You must attach a volume to mount your private key. This also means Key authentication is required.*
```bash
docker run \
    --name dohosossh \
    -t \
    -v $(pwd)/myprivate.key:/tunnel/private.key \
    -e AUTOSSH_REMOTE_USER=tunneluser  \
    -e AUTOSSH_REMOTE_HOST=172.18.0.1 \
    -e DOH_UPSTREAM_SERVERS=https://1.1.1.1/dns-query,https://8.8.8.8/dns-query \
    -p "53:53/udp" \
    cyberbutler/dohosossh
```

# Environment Variable Arguments
Use the following arguments to customize your configuration:
| Environment Variable | Description | Default |
| -------------------- | ----------- | ------- | 
| `AUTOSSH_REMOTE_HOST` | The SSH Target Host **required* | |
| `AUTOSSH_REMOTE_PORT` | The SSH Target Port **required* | |
| `AUTOSSH_REMOTE_USER` | The Remote User to Authenticate as **required* | |
| `AUTOSSH_MONITOR_PORT` | The Monitor Port used by `autossh` | `0` (Disabled) |
| `AUTOSSH_OPTIONS` | SSH Optional arguments. | `-N -o "StrictHostKeyChecking=no"` |
| `AUTOSSH_PRIVATE_KEYFILE` | The Private Key filepath | `/tunnel/private.key` | 
| `AUTOSSH_TUNNEL` | The SSH Port Forwarding argument. This is configurable so that you can set up other types of Port Forwards, like a Remote Forward in the case where you want to pull back a Proxy Port from another service accessible by the remote server. It is important that you bind the local address of 0.0.0.0 so that the port can be accessible via the Docker `publish` parameters. | `-D 0.0.0.0:8080` (DynamicForward) |
| `LOCAL_PROXY_ADDRESS` | The proxy address for cloudflared to route its https trafic through | `socks5://localhost:8080` |
| `DOH_UPSTREAM_SERVERS` |  A comma separated list of DoH servers | cloudflared's default DoH servers: `https://1.1.1.1/dns-query` `https://1.0.0.1/dns-query` |

