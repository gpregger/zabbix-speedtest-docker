# zabbix-speedtest-docker

## How to use this image

### Start `zabbix-agent`

Start a Zabbix agent container as follows:

    docker run --name some-zabbix-agent -e ZBX_HOSTNAME="some-hostname" -e ZBX_SERVER_HOST="some-zabbix-server" -d zabbix/zabbix-agent:tag

Where `some-zabbix-agent` is the name you want to assign to your container, `some-hostname` is the hostname, it is Hostname parameter in Zabbix agent configuration file, `some-zabbix-server` is IP or DNS name of Zabbix server or proxy and `tag` is the tag specifying the version you want. See the list above for relevant tags, or look at the [full list of tags](https://hub.docker.com/r/zabbix/zabbix-agent/tags/).

## 28.08.2021: SPEEDTEST_SERVER
This image now supports setting the desired speedtest server via docker environment variable SPEEDTEST_SERVER.
This schould make it substantially more useful to people around the world
